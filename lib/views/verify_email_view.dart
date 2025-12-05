import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  User? stateUser = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
        backgroundColor: Colors.orange,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Please verify your email address.'),
            TextButton(
              onPressed: () async {
                final user = FirebaseAuth.instance.currentUser;
                await user?.sendEmailVerification();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Verification email sent.')),
                );
                await user?.reload();
                devtools.log(user.toString());
                devtools.log(stateUser.toString());
                setState(() {
                  stateUser = FirebaseAuth.instance.currentUser;
                });
              },
              child: const Text('Email Verification'),
            ),
            Text(
              FirebaseAuth.instance.currentUser?.emailVerified.toString() ??
                  "No User Found",
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}