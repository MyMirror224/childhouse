import 'package:childhouse/contains/route.dart';

import 'package:childhouse/services/auth/bloc/auth_bloc.dart';
import 'package:childhouse/services/auth/bloc/auth_event.dart';
import 'package:childhouse/services/auth/bloc/auth_state.dart';
import 'package:childhouse/services/auth/firebase_auth_provider.dart';
import 'package:childhouse/view/notes/create_update_note_view.dart';

import 'package:childhouse/view/notes/view_notes.dart';
import 'package:childhouse/view/view_login.dart';
import 'package:childhouse/view/view_register.dart';
import 'package:childhouse/view/view_verify.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';



void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: BlocProvider(create: (context) => AuthBloc(FirebaseAuthProvider()),
    child:const  HomePage(),
    ),
    routes: {
      loginRoute: (context) => const ViewLogin(),
      registerRoute: (context) => const ViewRegister(),
      childhouseRoute: (context) => const NotesView(),
      verifyEmailRoute :(context) => const VerifyEmailView(),
      createOrUpdateNoteRoute: (context) => const CreateUpdateNoteView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AuthBloc>().add(const AuthEventInitialize());
    return BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          if( state is AuthStateLoggedIn){
            return const NotesView();
          } else if( state is AuthStateLoggedOut) {
            return const ViewLogin();
          } else if (state is AuthStateNeedsVerification){
            return const VerifyEmailView();
          } else {
            return const CircularProgressIndicator();
          }
        }
        );   
  }
}




