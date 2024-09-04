import 'package:app/app/config/theme_constants.dart';
import 'package:app/app/repositories/user_repository.dart';
import 'package:app/app/screens/login_screen/widgets/index_field.dart';
import 'package:app/app/screens/login_screen/widgets/login_button.dart';
import 'package:app/app/screens/login_screen/widgets/password_field.dart';
import 'package:app/app/screens/login_screen/widgets/register_now.dart';
import 'package:app/app/services/firebase_service.dart';
import 'package:app/app/utils/result_handler.dart';
import 'package:app/app/utils/toggle_loader.dart';
import 'package:flutter/material.dart';

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

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      try {
        showLoader(context);

        var result = await _userRepository.login(
          _indexController.text.trim(),
          _passwordController.text.trim(),
        );

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
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: null,
        builder: (context, snapshot) {
          return Scaffold(
              appBar: AppBar(),
              body: SingleChildScrollView(
                child: ConstrainedBox(
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
                  child: FirebaseService().currentUser != null
                      ? const Center(child: Text("You're signed in!"))
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Image.asset(
                                'assets/images/logo.webp',
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(
                                  ThemeConstants.paddingMedium),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    IndexField(
                                        indexController: _indexController),
                                    PasswordField(
                                        passwordController:
                                            _passwordController),
                                    LoginButton(onPressed: _signIn),
                                  ],
                                ),
                              ),
                            ),
                            const RegisterNow(),
                          ],
                        ),
                ),
              ));
        });
  }

  @override
  void dispose() {
    _indexController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
