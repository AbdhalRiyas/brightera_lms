const functions = require('firebase-functions');
const admin = require('firebase-admin');
const bcrypt = require('bcryptjs');

admin.initializeApp();

const db = admin.firestore();

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
        // Log the full error
        console.error('Error during authentication:', error);

        // Return an internal error with a detailed message
        throw new functions.https.HttpsError('internal', `Error during authentication: ${error.message}`);
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
        throw new functions.https.HttpsError('invalid-argument', 'Missing required fields.');
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