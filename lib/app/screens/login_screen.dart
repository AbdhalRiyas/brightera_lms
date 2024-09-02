import 'package:app/app/config/theme_constants.dart';
import 'package:app/app/repositories/user_repository.dart';
import 'package:app/app/services/user_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

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

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  void dispose() {
    _indexController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _userRepository.login(
          _indexController.text.trim(),
          _passwordController.text.trim(),
        );
        // Handle successful login, e.g., navigate to another screen
      } catch (e) {
        // Handle errors, e.g., show a snackbar or alert dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: ${e.toString()}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/logo.webp',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(ThemeConstants.paddingMedium),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                            bottom: ThemeConstants.paddingMedium,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(
                              ThemeConstants.borderRadiusLarge * 2,
                            ),
                          ),
                          child: TextFormField(
                            controller: _indexController,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              hintText: 'Index',
                              border: InputBorder.none,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your index number';
                              }
                              return null;
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                            bottom: ThemeConstants.paddingMedium,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(
                              ThemeConstants.borderRadiusLarge * 2,
                            ),
                          ),
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            textAlign: TextAlign.center,
                            decoration: const InputDecoration(
                              hintText: 'Password',
                              border: InputBorder.none,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              return null;
                            },
                          ),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ThemeConstants.primaryButtonColor,
                            foregroundColor:
                                ThemeConstants.primaryButtonTextColor,
                            minimumSize: const Size.fromHeight(50),
                          ),
                          onPressed: _signIn,
                          child: const Text("Login"),
                        ),
                      ],
                    ),
                  ),
                ),
                const Text("Don't have an account?"),
                TextButton(
                    onPressed: () {
                      showDialog(
                        useSafeArea: true,
                        context: context,
                        builder: (context) => AlertDialog(
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                "Want to register an account?",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(
                                  height: ThemeConstants.paddingMedium),
                              ElevatedButton.icon(
                                onPressed: () => _launchUrl(
                                    'https://api.whatsapp.com/send/?phone=918296935619&text=Register%20a%20Brightera%20Account&type=phone_number&app_absent=0'),
                                icon: SvgPicture.asset(
                                  'assets/icons/whatsapp.svg',
                                  colorFilter: const ColorFilter.mode(
                                      ThemeConstants.primaryButtonTextColor,
                                      BlendMode.srcIn),
                                ),
                                label: const Text("WhatsApp Us"),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(40),
                                  foregroundColor:
                                      ThemeConstants.primaryButtonTextColor,
                                  backgroundColor: const Color(0xFF25D366),
                                ),
                              ),
                              ElevatedButton.icon(
                                onPressed: () => _launchUrl('tel:8882192787'),
                                icon: SvgPicture.asset(
                                  'assets/icons/call.svg',
                                  height: 16,
                                  colorFilter: const ColorFilter.mode(
                                      ThemeConstants.primaryButtonTextColor,
                                      BlendMode.srcIn),
                                ),
                                label: const Text("Call Us"),
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size.fromHeight(40),
                                  foregroundColor:
                                      ThemeConstants.primaryButtonTextColor,
                                  backgroundColor:
                                      ThemeConstants.primaryButtonColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: const Text("Register Now")),
              ],
            ),
          ),
        ));
  }
}
