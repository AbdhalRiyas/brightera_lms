const functions = require('firebase-functions');
const admin = require('firebase-admin');
const bcrypt = require('bcryptjs');

admin.initializeApp();

const db = admin.firestore();
const config = functions.config();

// Constants for limitations
const MAX_OTPS_PER_PHONE = 3;
const MAX_OTPS_PER_IP = 10;
const OTP_EXPIRY_MINUTES = 10;
const OTP_RESEND_WAIT_MINUTES = 10;
const DEVICE_BLOCK_DURATION = 60; // in minutes

// SMS Gateway config
const SMS_GATEWAY_URL = config.sms.gateway.url;
const SMS_GATEWAY_USER_ID = config.sms.gateway.user_id;
const SMS_GATEWAY_API_KEY = config.sms.gateway.api_key;
const SMS_GATEWAY_SENDER_ID = config.sms.gateway.sender_id;

exports.requestOtp = functions.https.onCall(async (data, context) => {
    const { phoneNumber, deviceId } = data;
    const requestIp = context.rawRequest.ip;

    // Validate input
    if (!phoneNumber || !deviceId) {
        throw new functions.https.HttpsError('invalid-argument', 'Missing phone number or device ID.');
    }

    // Format phone number if necessary
    const formattedPhoneNumber = phoneNumber.startsWith('94') ? phoneNumber : '94' + phoneNumber.substring(1);

    // Check if the IP, phone number, or device ID is blocked
    if (await isBlocked(requestIp, formattedPhoneNumber, deviceId)) {
        throw new functions.https.HttpsError('permission-denied', 'Access blocked for security reasons.');
    }

    // Check daily OTP limits for the phone number
    const dailyLimitExceeded = await hasExceededDailyLimit(formattedPhoneNumber);
    if (dailyLimitExceeded) {
        throw new functions.https.HttpsError('resource-exhausted', 'Daily OTP request limit exceeded. Please try again tomorrow.');
    }

    // Check overall OTP limits
    const otpLimitExceeded = await hasExceededOtpLimits(requestIp, formattedPhoneNumber, deviceId);
    if (otpLimitExceeded) {
        throw new functions.https.HttpsError('resource-exhausted', 'Overall OTP request limit exceeded. Please try again later.');
    }

    // Check resend cooldown
    const canRequestOtp = await canRequestNewOtp(formattedPhoneNumber);
    if (!canRequestOtp) {
        throw new functions.https.HttpsError('failed-precondition', `Please wait ${OTP_RESEND_WAIT_MINUTES} minutes before requesting a new OTP.`);
    }

    // Generate and store OTP
    const otp = generateOtp();
    await storeOtp(formattedPhoneNumber, otp, requestIp, deviceId);

    // Send OTP via SMS Gateway
    try {
        await sendOtpSms(formattedPhoneNumber, otp);
        // Increment daily OTP count
        await incrementDailyOtpCount(formattedPhoneNumber);
        return { message: 'OTP sent successfully.' };
    } catch (error) {
        console.error('Error sending OTP:', error);
        throw new functions.https.HttpsError('internal', 'Failed to send OTP. Please try again later.');
    }
});

// Function to verify OTP
exports.verifyOtp = functions.https.onCall(async (data, context) => {
    const { phoneNumber, otp, deviceId } = data;

    // Validate input
    if (!phoneNumber || !otp || !deviceId) {
        throw new functions.https.HttpsError('invalid-argument', 'Missing phone number, OTP, or device ID.');
    }

    // Format phone number if necessary
    const formattedPhoneNumber = phoneNumber.startsWith('94') ? phoneNumber : '94' + phoneNumber.substring(1);

    // Retrieve OTP data
    const otpData = await getOtpData(formattedPhoneNumber);

    if (!otpData) {
        throw new functions.https.HttpsError('not-found', 'OTP not found. Please request a new one.');
    }

    // Check OTP expiration
    const otpAgeMinutes = (Date.now() - otpData.timestamp.toDate().getTime()) / 60000; // Fixing division by 60000 for correct minute calculation
    if (otpAgeMinutes > OTP_EXPIRY_MINUTES) {
        await blockDevice(deviceId, DEVICE_BLOCK_DURATION);
        throw new functions.https.HttpsError('deadline-exceeded', 'OTP has expired. Please request a new one.');
    }

    // Verify OTP
    if (otpData.otp !== otp) {
        await incrementFailedAttempts(formattedPhoneNumber, deviceId);
        throw new functions.https.HttpsError('invalid-argument', 'Incorrect OTP. Please try again.');
    }

    // Clear OTP data on successful verification
    await clearOtpData(formattedPhoneNumber);

    // Check if user exists in the Firestore 'users' collection
    const userSnapshot = await db.collection('users').doc(formattedPhoneNumber).get();

    if (userSnapshot.exists) {
        // User exists, retrieve user data
        const userData = userSnapshot.data();

        // Generate a custom token for the existing user
        const customToken = await admin.auth().createCustomToken(formattedPhoneNumber, {
            role: userData.userRole || 'student', // default role if not set
            name: userData.name,
            mobileNumber: userData.mobileNumber || formattedPhoneNumber
        });

        console.log(`Custom token generated for user: ${formattedPhoneNumber}`);

        return { token: customToken };
    } else {
        // User does not exist, create a new user document
        const newUserData = {
            name: 'New Student', // Default name, can be updated later
            mobileNumber: formattedPhoneNumber,
            userRole: 'student', // Default role
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
            updatedAt: admin.firestore.FieldValue.serverTimestamp()
        };

        await db.collection('users').doc(formattedPhoneNumber).set(newUserData);

        console.log(`New user created for phone number: ${formattedPhoneNumber}`);

        // Generate a custom token for the new user
        const customToken = await admin.auth().createCustomToken(formattedPhoneNumber, {
            role: newUserData.userRole,
            name: newUserData.name,
            mobileNumber: newUserData.mobileNumber
        });

        console.log(`Custom token generated for new user: ${formattedPhoneNumber}`);

        return { token: customToken };
    }
});

// Utility Functions

function generateOtp() {
    return crypto.randomInt(100000, 999999).toString();
}

async function sendOtpSms(phoneNumber, otp) {
    const message = `Your verification code is ${otp}. It will expire in ${OTP_EXPIRY_MINUTES} minutes.`;
    const params = new URLSearchParams({
        user_id: SMS_GATEWAY_USER_ID,
        api_key: SMS_GATEWAY_API_KEY,
        sender_id: SMS_GATEWAY_SENDER_ID,
        to: phoneNumber,
        message: message
    });

    await axios.post(SMS_GATEWAY_URL, params);
}

async function storeOtp(phoneNumber, otp, ip, deviceId) {
    await db.collection('otpRequests').doc(phoneNumber).set({
        otp: otp,
        timestamp: admin.firestore.FieldValue.serverTimestamp(),
        ip: ip,
        deviceId: deviceId,
        failedAttempts: 0
    });

    // Log the request to enforce limits
    await logOtpRequest(ip, phoneNumber, deviceId);
}

async function getOtpData(phoneNumber) {
    const otpDoc = await db.collection('otpRequests').doc(phoneNumber).get();
    return otpDoc.exists ? otpDoc.data() : null;
}

async function clearOtpData(phoneNumber) {
    await db.collection('otpRequests').doc(phoneNumber).delete();
}

async function incrementFailedAttempts(phoneNumber, deviceId) {
    const otpDocRef = db.collection('otpRequests').doc(phoneNumber);
    const otpDoc = await otpDocRef.get();

    if (otpDoc.exists) {
        const data = otpDoc.data();
        const newFailedAttempts = (data.failedAttempts || 0) + 1;

        if (newFailedAttempts >= 3) {
            await blockDevice(deviceId, DEVICE_BLOCK_DURATION);
        }

        await otpDocRef.update({ failedAttempts: newFailedAttempts });
    }
}

async function logOtpRequest(ip, phoneNumber, deviceId) {
    // Track the OTP request for limits enforcement
    const now = admin.firestore.FieldValue.serverTimestamp();
    await db.collection('otpLogs').add({ ip, phoneNumber, deviceId, timestamp: now });
}

async function hasExceededOtpLimits(ip, phoneNumber, deviceId) {
    const twentyFourHoursAgo = admin.firestore.Timestamp.fromMillis(Date.now() - 24 * 60 * 60 * 1000);

    // Check OTP requests from the same IP
    const ipRequestCount = await db.collection('otpLogs')
        .where('ip', '==', ip)
        .where('timestamp', '>', twentyFourHoursAgo)
        .get()
        .then(snapshot => snapshot.size);

    if (ipRequestCount >= MAX_OTPS_PER_IP) {
        return true;
    }

    // Check OTP requests from the same phone number
    const phoneRequestCount = await db.collection('otpLogs')
        .where('phoneNumber', '==', phoneNumber)
        .where('timestamp', '>', twentyFourHoursAgo)
        .get()
        .then(snapshot => snapshot.size);

    if (phoneRequestCount >= MAX_OTPS_PER_PHONE) {
        return true;
    }

    return false;
}

async function canRequestNewOtp(phoneNumber) {
    const otpDoc = await db.collection('otpRequests').doc(phoneNumber).get();

    if (otpDoc.exists) {
        const otpData = otpDoc.data();
        const lastRequestTime = otpData.timestamp.toDate().getTime();
        const now = Date.now();
        const minutesSinceLastRequest = (now - lastRequestTime) / 60000;

        if (minutesSinceLastRequest < OTP_RESEND_WAIT_MINUTES) {
            return false;
        }
    }

    return true;
}

async function isBlocked(ip, phoneNumber, deviceId) {
    const blocksRef = db.collection('blocked');
    const blockDocs = await blocksRef.where('ip', '==', ip)
        .where('phoneNumber', '==', phoneNumber)
        .where('deviceId', '==', deviceId)
        .where('unblockAt', '>', admin.firestore.FieldValue.serverTimestamp())
        .get();

    return !blockDocs.empty;
}

async function blockDevice(deviceId, durationInMinutes) {
    const unblockAt = admin.firestore.Timestamp.fromMillis(Date.now() + durationInMinutes * 60000);
    await db.collection('blocked').add({ deviceId, unblockAt });
}

async function hasExceededDailyLimit(phoneNumber) {
    const dailyLimitRef = db.collection('dailyOtpLimits').doc(phoneNumber);
    const limitDoc = await dailyLimitRef.get();

    if (limitDoc.exists) {
        const data = limitDoc.data();
        const today = new Date().toISOString().split('T')[0];

        if (data.date === today && data.count >= MAX_OTPS_PER_PHONE) {
            return true;
        }
    }

    return false;
}

async function incrementDailyOtpCount(phoneNumber) {
    const dailyLimitRef = db.collection('dailyOtpLimits').doc(phoneNumber);
    const limitDoc = await dailyLimitRef.get();
    const today = new Date().toISOString().split('T')[0];

    if (limitDoc.exists) {
        const data = limitDoc.data();

        if (data.date === today) {
            await dailyLimitRef.update({ count: data.count + 1 });
        } else {
            await dailyLimitRef.set({ date: today, count: 1 });
        }
    } else {
        await dailyLimitRef.set({ date: today, count: 1 });
    }
}

exports.customAuth = functions.https.onCall(async (data, context) => {
    const { indexNumber, password } = data;

    if (!indexNumber || !password) {
        throw new functions.https.HttpsError('invalid-argument', 'Missing index number or password.');
    }

    try {
        // Log input data for debugging
        console.log(`Received auth request for index number: ${indexNumber}`);

        // Retrieve the user document based on the index number
        const userSnapshot = await db.collection('users').doc(indexNumber).get();

        if (!userSnapshot.exists) {
            throw new functions.https.HttpsError('unauthenticated', 'Invalid index number or password.');
        }

        const userData = userSnapshot.data();

        // Log user data retrieval
        console.log(`User data retrieved for index number: ${indexNumber}`);

        // Check if the password is valid
        const isPasswordValid = await bcrypt.compare(password, userData.password);

        if (isPasswordValid) {
            // Generate a custom token for the user
            const customToken = await admin.auth().createCustomToken(indexNumber, {
                role: userData.userRole,
                name: userData.name,
                mobileNumber: userData.mobileNumber
            });

            // Log token generation
            console.log(`Custom token generated for index number: ${indexNumber}`);

            return { token: customToken };
        } else {
            throw new functions.https.HttpsError('unauthenticated', 'Invalid index number or password.');
        }
    } catch (error) {
        if (error instanceof functions.https.HttpsError) {
            throw error;
        } else {
            throw new functions.https.HttpsError('internal', 'Error during authentication: ' + error.message);
        }
    }
});


exports.createUser = functions.https.onCall(async (data, context) => {
    // Optional: Check if the user is authenticated
    // if (!context.auth) {
    //     throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated to create a new user.');
    // }

    const { indexNumber, plainPassword, name, mobileNumber, userRole } = data;

    // Validate input fields
    if (!indexNumber || !plainPassword || !name || !mobileNumber || !userRole) {
        throw new functions.https.HttpsError('invalid-argument', 'Missing requfired fields.');
    }

    // Check if user already exists
    const userDoc = await admin.firestore().collection('users').doc(indexNumber).get();

    if (userDoc.exists) {
        // User already exists
        throw new functions.https.HttpsError('already-exists', 'User ID already exists.');
    }

    try {
        // Hash the password
        const hashedPassword = await bcrypt.hash(plainPassword, 10);
        const createdAt = admin.firestore.Timestamp.now();

        // Store the user in Firestore
        await admin.firestore().collection('users').doc(indexNumber).set({
            indexNumber: indexNumber,
            password: hashedPassword,
            name: name,
            mobileNumber: mobileNumber,
            createdAt: createdAt,
            userRole: userRole,
        });

        return { message: 'User created successfully' };
    } catch (error) {
        console.error('Error creating user:', error);
        throw new functions.https.HttpsError('internal', 'Error creating user.');
    }
});