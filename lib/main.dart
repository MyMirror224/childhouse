import 'package:childhouse/contains/route.dart';
import 'package:childhouse/services/auth/auth_service.dart';
import 'package:childhouse/view/notes/create_update_note_view.dart';

import 'package:childhouse/view/notes/view_notes.dart';
import 'package:childhouse/view/view_login.dart';
import 'package:childhouse/view/view_register.dart';
import 'package:childhouse/view/view_verify.dart';

import 'package:flutter/material.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const HomePage(),
    routes: {
      loginRoute: (context) => const ViewLogin(),
      registerRoute: (context) => const ViewRegister(),
      childhouseRoute: (context) => const NotesView(),
      verifyRoute :(context) => const VerifyEmailView(),
      createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: AuthService.firebase().initialize(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final user = AuthService.firebase().currentUser;
              if (user != null) {
                if (user.isEmailVerify) {
                  return const NotesView();
                } else {
                  return const VerifyEmailView();
                }
              }
              return const ViewLogin();
            default:
              return const CircularProgressIndicator();
          }
        });
  }
}




