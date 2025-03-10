import 'package:app/src/config/theme_constants.dart';
import 'package:app/src/screens/login_screen/widgets/mobile_number_field.dart';
import 'package:app/src/utils/format_seconds.dart';
import 'package:app/src/widgets/primary_button.dart';
import 'package:app/src/services/firebase_service.dart';
import 'package:app/src/utils/get_primary_icon_color.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:sms_autofill/sms_autofill.dart';

import 'logic/login_screen_logic.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with LoginScreenLogic {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
      stream: null,
      builder: (context, snapshot) {
        return GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
            ),
            extendBodyBehindAppBar: true,
            body: Stack(
              children: [
                Positioned(
                  top: -180,
                  left: -100,
                  child: Transform.rotate(
                    angle: 60 * (3.141592653589793 / 180),
                    child: SvgPicture.asset(
                      "assets/icons/brightera.svg",
                      height: 450,
                      colorFilter: ColorFilter.mode(
                        ThemeConstants.primaryColor.withValues(alpha: 0.1),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height -
                        kToolbarHeight -
                        MediaQuery.of(context).padding.top -
                        MediaQuery.of(context).padding.bottom,
                  ),
                  child: FirebaseService().currentUser != null
                      ? const Center(child: Text("You're signed in!"))
                      : Padding(
                          padding: const EdgeInsets.all(
                              ThemeConstants.paddingMedium),
                          child: !otpCodeSent
                              ? _buildPhoneNumberScreen()
                              : _buildOtpScreen(),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Column _buildPhoneNumberScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          "assets/icons/brightera.svg",
          height: 150,
          colorFilter: getPrimaryIconColor(),
        ),
        const SizedBox(height: ThemeConstants.paddingMedium),
        SvgPicture.asset(
          "assets/images/logo.svg",
          height: 50,
          colorFilter: getPrimaryIconColor(),
        ),
        const SizedBox(height: ThemeConstants.paddingMedium * 4),
        Form(
          key: formKey,
          child: Column(
            children: [
              MobileNumberField(indexController: indexController),
              const SizedBox(height: ThemeConstants.paddingMedium),
              PrimaryButton(
                onPressed: signIn,
                text: "Login or Register",
              ),
            ],
          ),
        ),
        const SizedBox(height: ThemeConstants.paddingLarge * 2),
        const Text(
          "If you are creating a new account, Terms & Conditions and Privacy Policy will apply.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 10,
          ),
        ),
      ],
    );
  }

  Column _buildOtpScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "Verify $phoneNumber",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: ThemeConstants.paddingMedium),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text:
                'Waiting to automatically detect an SMS sent to $phoneNumber. ',
            style: const TextStyle(color: Colors.black),
            children: <TextSpan>[
              TextSpan(
                text: 'Wrong number?',
                style: const TextStyle(
                  color: ThemeConstants.primaryColor,
                  decoration: TextDecoration.underline,
                ),
                recognizer: TapGestureRecognizer()..onTap = changePhoneNumber,
              ),
            ],
          ),
        ),
        PinFieldAutoFill(
          autoFocus: true,
          controller: otpController,
          codeLength: 6,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.number,
          onCodeChanged: (code) {
            if (otpController.text.length == 6) {
              // Check the length of the code directly
              verifyOtp(otpController.text); // Call the verification function
            }
          },
          onCodeSubmitted: (code) => verifyOtp(code),
          // Add this line to make it typable on Flutter web
          currentCode: otpController.text,
        ),
        const SizedBox(height: ThemeConstants.paddingSmall),
        const Text(
          "Enter 6-digit code",
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: ThemeConstants.paddingLarge),
        ValueListenableBuilder<int>(
          valueListenable: remainingSeconds,
          builder: (BuildContext context, int value, Widget? child) => ListTile(
            leading: Icon(
              Icons.sms,
              color: value == 0 ? ThemeConstants.primaryColor : null,
            ),
            title: Text(
              "Resend SMS",
              style: value == 0
                  ? const TextStyle(color: ThemeConstants.primaryColor)
                  : null,
            ),
            trailing: value != 0 ? Text(formatSeconds(value)) : null,
            onTap: value == 0 ? resendSms : null,
          ),
        ),
      ],
    );
  }
}
