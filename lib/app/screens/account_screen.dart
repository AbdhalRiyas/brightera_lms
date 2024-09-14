import 'package:app/app/models/user.dart' show UserRole;
import 'package:app/app/services/auth_manager.dart';
import 'package:app/app/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseService().authStateChanges, // Assuming this stream exists
      builder: (context, snapshot) {
        final currentUser = snapshot.data;

        return Scaffold(
          appBar: AppBar(
            title: const Text("Account"),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                if (currentUser != null)
                  FutureBuilder(
                    future: AuthManager().getUserDetails(),
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
                                const Icon(Icons.key),
                                Text(
                                  currentUser.uid,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            if (snapshot.data?['userRole'] !=
                                UserRole.student.name)
                              TextButton(
                                onPressed: () => Navigator.pushReplacementNamed(
                                    context, '/dashboard'),
                                child: const Text(
                                  "Switch to instructor view",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        );
                      }

                      return const SizedBox();
                    },
                  ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextButton(
                      onPressed: currentUser != null
                          ? _signOut
                          : () => Navigator.pushNamed(context, '/login'),
                      child: Text(
                        currentUser != null ? "Sign out" : "Sign In",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _signOut() async {
    await FirebaseService().singOut();
  }
}
