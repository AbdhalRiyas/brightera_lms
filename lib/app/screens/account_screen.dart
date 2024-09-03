import 'package:app/app/services/auth_manager.dart';
import 'package:app/app/services/firebase_service.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    final userDetails = AuthManager().getUserDetails();
    return Scaffold(
        appBar: AppBar(
          title: const Text("Account"),
        ),
        body: FirebaseService().currentUser != null
            ? FutureBuilder(
                future: userDetails,
                builder: (BuildContext context,
                    AsyncSnapshot<Map<String, dynamic>?> snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          snapshot.data?['name'] ?? '',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 28,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.key),
                            Text(
                              FirebaseService().currentUser!.uid,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        TextButton(
                          onPressed: _signOut,
                          child: const Text("Logout"),
                        )
                      ],
                    );
                  }

                  return const SizedBox();
                },
              )
            : const Column());
  }

  Future<void> _signOut() async {
    await FirebaseService().singOut();
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/',
        (route) => false,
      );
    }
  }
}
