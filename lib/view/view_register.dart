import 'package:childhouse/contains/route.dart';
import 'package:childhouse/utilities/show_error_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;

import '../firebase_options.dart';

class ViewRegister extends StatefulWidget {
  const ViewRegister({super.key});

  @override
  State<ViewRegister> createState() => _ViewRegisterState();
}

class _ViewRegisterState extends State<ViewRegister> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
        ),
        body: FutureBuilder(
            future: Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform,
            ),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  return Column(
                    children: [
                      TextField(
                        controller: _email,
                        enableSuggestions: false,
                        autocorrect: false,
                        keyboardType: TextInputType.emailAddress,
                        decoration:
                            const InputDecoration(hintText: "Write your Email"),
                      ),
                      TextField(
                        controller: _password,
                        enableSuggestions: false,
                        autocorrect: false,
                        obscureText: true,
                        decoration: const InputDecoration(
                            hintText: "Write your Password"),
                      ),
                      TextButton(
                          onPressed: () async {
                            try {
                              final email = _email.text;
                              final password = _password.text;
                               await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                email: email,
                                password: password,
                              );
                              
                            } on FirebaseAuthException catch (e) {
                              if (e.code == "invalid-email") {
                                await showErrorDialog(
                                  context,
                                  "invalid-email",
                                );
                              } else if (e.code == "weak-password") {
                                await showErrorDialog(
                                  context,
                                  "Weak password",
                                );
                              } else if (e.code == "email-already-in-use") {
                                await showErrorDialog(
                                  context,
                                  "Email is used ",
                                );
                              }
                            } catch (e) {
                              showErrorDialog(context, e.toString());
                            }
                          },
                          child: const Text("Resgiter")),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              loginview,
                              (route) => false,
                            );
                          },
                          child: const Text("Already Register? Login here!"))
                    ],
                  );
                default:
                  return const Text("Loading....");
              }
            }));
  }
}
