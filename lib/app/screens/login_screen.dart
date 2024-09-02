import 'package:app/app/config/theme_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
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
                      child: Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                            bottom: ThemeConstants.paddingMedium),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(
                              ThemeConstants.borderRadiusLarge * 2),
                        ),
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            hintText: 'Index',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            bottom: ThemeConstants.paddingMedium),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(
                              ThemeConstants.borderRadiusLarge * 2),
                        ),
                        child: TextFormField(
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            hintText: 'Password',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ThemeConstants.primaryButtonColor,
                          foregroundColor:
                              ThemeConstants.primaryButtonTextColor,
                          minimumSize: const Size.fromHeight(50), // NEW
                        ),
                        onPressed: () {},
                        child: const Text("Login"),
                      )
                    ],
                  )),
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
