import 'package:app/app/services/user_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            if (UserManager().userDetails != null)
              TextButton(
                  onPressed: () async {
                    try {
                      await FirebaseAuth.instance.signOut();
                      print('signed out');
                    } on Exception catch (e) {
                      print(e);
                    }
                  },
                  child: Text("Logout"))
          ],
        ));
  }
}
