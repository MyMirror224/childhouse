
import 'package:childhouse/services/auth/bloc/auth_bloc.dart';
import 'package:childhouse/services/auth/bloc/auth_event.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const  Padding(
              padding:  EdgeInsets.all(16.0),
              child:  Text(
                "We've sent you an email verification. Please open it to verify your account. If you haven't received a verification email yet, press the button below!"
              ),
            ),
          TextButton(
              onPressed: () async {
                context.read<AuthBloc>().add(
                  const AuthEventSendEmailVerification()
                );
              },
              child: const Text("Send email verification")),
          TextButton(
              onPressed: () async {
                
                context.read<AuthBloc>().add(
                  const AuthEventLogout()
                );
              },
              child: const Text("Back to Login"))
        ]),
      ),
    );
  }
}
