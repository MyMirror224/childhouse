
import 'package:childhouse/services/auth/bloc/auth_bloc.dart';
import 'package:childhouse/services/auth/bloc/auth_event.dart';
import 'package:childhouse/services/auth/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/auth/auth_exception.dart';
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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateLoggedOut) {
          if (state.exception is UseNotFoundAuthException) {
            await showErrorDialog(
              context,
              "Cannot find a user with the entered credentials!",
            );
          } else if (state.exception is WrongPasswordAuthException) {
            await showErrorDialog(
              context,
              "Wrong credentials",
            );
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(
              context,
              "Authentication error",
            );
          }
        }
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Login'),
          ),
          body: Padding(
              padding: const EdgeInsets.all(12.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text(
                        "Please log in to your account in order to interact with and create notes!"),
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

                          context
                              .read<AuthBloc>()
                              .add(AuthEventLogin(email, password));
                        },
                        child: const Text("Login")),
                    TextButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(
                              const AuthEventForgotPassword(),
                            );
                      },
                      child: const Text(
                        "I forgot my password",
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          context
                              .read<AuthBloc>()
                              .add(const AuthEventShouldRegister());
                        },
                        child: const Text("Not Registered yet? Register here!"))
                  ],
                ),
              ))),
    );
  }
}
