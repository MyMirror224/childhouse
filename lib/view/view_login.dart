import 'package:childhouse/contains/route.dart';
import 'package:childhouse/utilities/show_error_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as devtools show log;
import '../firebase_options.dart';

class ViewLogin extends StatefulWidget {
  const ViewLogin({super.key});

  @override
  State<ViewLogin> createState() => _ViewLoginState();
}

class _ViewLoginState extends State<ViewLogin> {
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
          title: const Text('Login'),
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
                                  .signInWithEmailAndPassword(
                                email: email,
                                password: password,
                              );
                              // ignore: use_build_context_synchronously
                              Navigator.of(context)
                                  .pushNamedAndRemoveUntil(
                                childhouseview,
                                (_) => false,
                              );
                            } on FirebaseAuthException catch (e) {
                              if (e.code == "user-not-found") {
                                await showErrorDialog(context,"User not found" );
                              } else if (e.code == "wrong-password") {
                                await showErrorDialog(context,"Wrong password" );
                              } else if (e.code == "invalid-email") {
                                await showErrorDialog(context,"Invalid email" );
                              } 
                            } catch (e){
                              await showErrorDialog(context, e.toString());
                            }
                          },
                          child: const Text("Login")),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              registerview,
                              (_) => false,
                            );
                          },
                          child:
                              const Text("Not Registered yet? Register here!"))
                    ],
                  );
                default:
                  return const Text("Loading....");
              }
            }));
  }
  
}

