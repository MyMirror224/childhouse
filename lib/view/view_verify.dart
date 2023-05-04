import 'package:childhouse/contains/route.dart';
import 'package:childhouse/services/auth/auth_service.dart';

import 'package:flutter/material.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verify_Email")),
      body: Column(children: [
        const Text("Verify Email sent for you"),
        const Text("if you haven't reveice mail, please Send Verify below "),
        TextButton(
            onPressed: () async {
              await AuthService.firebase().sendEmailVerification();
            },
            child: const Text("Send email verification")),
        TextButton(
            onPressed: () async {
              final navigator =Navigator.of(context);
              await AuthService.firebase().logOut();
              navigator.pushNamedAndRemoveUntil(
                loginRoute,
                (route) => false,
              );
            },
            child: const Text("Back to Login"))
      ]),
    );
  }
}
