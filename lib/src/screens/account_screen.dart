import 'package:app/src/models/user.dart' show UserRole;
import 'package:app/src/services/auth_manager.dart';
import 'package:app/src/services/firebase_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'orders_screen.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key, this.isInstructorView = false});

  final bool isInstructorView;

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
                                    context,
                                    widget.isInstructorView
                                        ? '/'
                                        : '/dashboard'),
                                child: Text(
                                  "Switch to ${widget.isInstructorView ? 'student' : 'instructor'} view",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ListTile(
                              title: const Text('Orders'),
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const OrdersScreen())),
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
