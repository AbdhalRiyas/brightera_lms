import 'package:app/app/config/theme_constants.dart';
import 'package:app/app/repositories/user_repository.dart';
import 'package:app/app/screens/login_screen/widgets/index_field.dart';
import 'package:app/app/screens/login_screen/widgets/login_button.dart';
import 'package:app/app/services/firebase_service.dart';
import 'package:app/app/utils/get_primary_icon_color.dart';
import 'package:app/app/utils/result_handler.dart';
import 'package:app/app/utils/toggle_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final UserRepository _userRepository = UserRepository();
  final _indexController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _otpCodeSent = false;

  Future<void> _signIn() async {
    // if (_formKey.currentState!.validate()) {
    //   try {
    //     showLoader(context);

    //     var result = await _userRepository.login(
    //       _indexController.text.trim(),
    //       _passwordController.text.trim(),
    //     );

    //     if (mounted) {
    //       hideLoader(context);

    //       if (result.isSuccess) {
    //         ResultHandler()
    //             .showSuccess(context, result.data ?? 'Sign in successful');
    //         Navigator.pop(context); // back to previous screen
    //       } else {
    //         ResultHandler()
    //             .showError(context, result.error ?? 'Sign in unsuccessful');
    //       }
    //     }
    //   } catch (e) {
    //     if (mounted) {
    //       ResultHandler().showError(context, 'Login failed: ${e.toString()}');
    //     }
    //   }
    // }
  }

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
                          colorFilter: const ColorFilter.mode(
                            Color(0xFFEBE0EB),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height -
                            kToolbarHeight - // Exclude the AppBar height
                            MediaQuery.of(context)
                                .padding
                                .top - // Exclude the status bar height
                            MediaQuery.of(context)
                                .padding
                                .bottom, // Exclude the bottom notch or system UI height
                      ),
                      child: FirebaseService().currentUser == null
                          ? const Center(child: Text("You're signed in!"))
                          : Padding(
                              padding: const EdgeInsets.all(
                                  ThemeConstants.paddingMedium),
                              child: !_otpCodeSent
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SvgPicture.asset(
                                          "assets/icons/brightera.svg",
                                          height: 150,
                                          colorFilter: getPrimaryIconColor(),
                                        ),
                                        const SizedBox(
                                            height:
                                                ThemeConstants.paddingMedium),
                                        SvgPicture.asset(
                                          "assets/images/logo.svg",
                                          height: 50,
                                          colorFilter: getPrimaryIconColor(),
                                        ),
                                        const SizedBox(
                                            height:
                                                ThemeConstants.paddingMedium *
                                                    4),
                                        Form(
                                          key: _formKey,
                                          child: Column(
                                            children: [
                                              IndexField(
                                                  indexController:
                                                      _indexController),
                                              // PasswordField(
                                              //     passwordController:
                                              //         _passwordController),
                                              const SizedBox(
                                                  height: ThemeConstants
                                                      .paddingMedium),
                                              LoginButton(onPressed: _signIn),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                            height:
                                                ThemeConstants.paddingLarge *
                                                    2),
                                        const Text(
                                          "If you are creating a new account, Terms & Conditions and Privacy Policy will apply.",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    )
                                  : const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        Text(
                                          "Validate Your OTP",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(fontSize: 22),
                                        ),
                                        Text(
                                          "Please verify your phone number to login. We have sent an OTP to the below mentioned number. (OTP) will be valid for 10 mins)",
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          "7676757470",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        TextField()
                                      ],
                                    ),
                            ),
                    ),
                  ],
                )),
          );
        });
  }

  @override
  void dispose() {
    _indexController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
