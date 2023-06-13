import 'package:childhouse/contains/route.dart';
import 'package:childhouse/services/auth/auth_service.dart';
import 'package:childhouse/services/auth/bloc/auth_bloc.dart';
import 'package:childhouse/services/auth/bloc/auth_event.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../utilities/dialogs/error_dialog.dart';


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
        body:  Column(
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
                            final email = _email.text;
                              final password = _password.text;
                            try {
                              
                              context.read<AuthBloc>().add( AuthEventLogin(email, password));
                              final user = AuthService.firebase().currentUser;
                              
                                if (user?.isEmailVerify ?? false) {
                                  // ignore: use_build_context_synchronously
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                childhouseRoute,
                                (_) => false,
                              );
                                } else {
                                  // ignore: use_build_context_synchronously
                                  Navigator.of(context).pushNamedAndRemoveUntil(
                                verifyEmailRoute,
                                (_) => false,
                              );
                                }
                              
                              // ignore: use_build_context_synchronously
                              
                            } on FirebaseAuthException catch (e) {
                              if (e.code == "user-not-found") {
                                await showErrorDialog(
                                    context, "User not found");
                              } else if (e.code == "wrong-password") {
                                await showErrorDialog(
                                    context, "Wrong password");
                              } else if (e.code == "invalid-email") {
                                await showErrorDialog(context, "Invalid email");
                              }
                            } catch (e) {
                              await showErrorDialog(context, e.toString());
                            }
                          },
                          child: const Text("Login")),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              registerRoute,
                              (_) => false,
                            );
                          },
                          child:
                              const Text("Not Registered yet? Register here!"))
                    ],
                  )   
            );
  }
}
