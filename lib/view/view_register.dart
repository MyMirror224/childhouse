
import 'package:childhouse/services/auth/bloc/auth_bloc.dart';
import 'package:childhouse/services/auth/bloc/auth_event.dart';
import 'package:childhouse/services/auth/bloc/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/auth/auth_exception.dart';
import '../utilities/dialogs/error_dialog.dart';

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
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (state is AuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            await showErrorDialog(
              context,
              "This password is not secure enough. Please choose another password!",
            );
          } else if (state.exception is EmailAlreadyInUseAuthException) {
            await showErrorDialog(
              context,
              "This email is already registered to another user. Please choose another email!",
            );
          } else if (state.exception is GenericAuthException) {
            await showErrorDialog(
              context,
              "Failed to register. Please try again later!",
            );
          } else if (state.exception is InvalidEmailAuthException) {
            await showErrorDialog(
              context,
              "The email address you entered appears to be invalid. Please try another email address!",
            );
          }
        }
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Register'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(12.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                    decoration:
                        const InputDecoration(hintText: "Write your Password"),
                  ),
                  TextButton(
                      onPressed: () async {
                        
                          final email = _email.text;
                          final password = _password.text;
                          context.read<AuthBloc>().add(
                             AuthEventRegister(email, password)
                          );
                      },
                      child: const Text("Resgiter")),
                  TextButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(const AuthEventLogout());
                      },
                      child: const Text("Already Register? Login here!"))
                ],
              ),
            ),
          )),
    );
  }
}
