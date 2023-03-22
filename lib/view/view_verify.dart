import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(title: const Text("Verify_Email")),
      body: Column(children: [
            const Text("Verify Email sent for you"),
            const Text("if you haven't reveice mail, please Send Verify below "),
            TextButton(onPressed: () async {
               final use = FirebaseAuth.instance.currentUser;
               await use?.sendEmailVerification();
              
            }, child: const Text("Send email verification"))
        ]),
    );
  }
}

