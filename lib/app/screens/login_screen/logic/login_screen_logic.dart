import 'dart:async';

import 'package:app/app/repositories/user_repository.dart';
import 'package:app/app/utils/result.dart';
import 'package:app/app/utils/result_handler.dart';
import 'package:app/app/utils/toggle_loader.dart';
import 'package:flutter/material.dart';

mixin LoginScreenLogic<LoginScreen extends StatefulWidget>
    on State<LoginScreen> {
  final formKey = GlobalKey<FormState>();
  final UserRepository _userRepository = UserRepository();

  final indexController = TextEditingController();
  final otpController = TextEditingController();

  String phoneNumber = '';
  bool otpCodeSent = false;

  final int _resendTime = 1 * 60;

  Timer? _timer;
  final ValueNotifier<int> remainingSeconds =
      ValueNotifier(1 * 60); // 10 minutes

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingSeconds.value > 0) {
        remainingSeconds.value--;
      } else {
        _timer?.cancel();
        // Handle timer completion if needed
      }
    });
  }

  Future<void> signIn([bool resend = false]) async {
    if (resend || formKey.currentState!.validate()) {
      try {
        showLoader(context, "Sending OTP, Please wait...");

        String currentPhoneNumber =
            resend ? phoneNumber : indexController.text.trim();
        currentPhoneNumber = currentPhoneNumber.startsWith('0')
            ? currentPhoneNumber.substring(1)
            : currentPhoneNumber;

        final Result result = await _userRepository.login(currentPhoneNumber);

        if (mounted) {
          hideLoader(context);

          if (result.isSuccess) {
            _startTimer();
            setState(() {
              otpCodeSent = true;
              phoneNumber = resend ? phoneNumber : indexController.text.trim();
            });
            ResultHandler()
                .showSuccess(context, result.data ?? 'OTP code has been sent!');
          } else {
            ResultHandler()
                .showError(context, result.error ?? "Couldn't send OTP code.");
          }
        }
      } catch (e) {
        if (mounted) {
          ResultHandler()
              .showError(context, 'Verification failed: ${e.toString()}');
        }
      }
    }
  }

  Future<void> verifyOtp(String otp) async {
    try {
      showLoader(context, "Verifying OTP, Please wait...");

      String currentPhoneNumber = phoneNumber;
      currentPhoneNumber = currentPhoneNumber.startsWith('0')
          ? currentPhoneNumber.substring(1)
          : currentPhoneNumber;

      Result result =
          await _userRepository.verifyPhoneNumber("94$currentPhoneNumber", otp);

      if (mounted) {
        hideLoader(context);

        if (result.isSuccess) {
          ResultHandler()
              .showSuccess(context, result.data ?? 'Sign in successful');
          Navigator.pop(context); // back to previous screen
        } else {
          ResultHandler()
              .showError(context, result.error ?? 'Sign in unsuccessful');
        }
      }
    } catch (e) {
      if (mounted) {
        ResultHandler().showError(context, 'Login failed: ${e.toString()}');
      }
    }
  }

  void resendSms() {
    _timer?.cancel();
    remainingSeconds.value = _resendTime;
    signIn(true);
  }

  void changePhoneNumber([bool render = true]) {
    _timer?.cancel();
    indexController.clear();
    otpController.clear();
    remainingSeconds.value = _resendTime;
    if (render) {
      setState(() {
        phoneNumber = '';
        otpCodeSent = false;
      });
    }
  }

  @override
  void dispose() {
    changePhoneNumber(false);
    super.dispose();
  }
}
