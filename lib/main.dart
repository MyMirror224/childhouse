import 'package:childhouse/contains/route.dart';
import 'package:childhouse/view/view_login.dart';
import 'package:childhouse/view/view_register.dart';
import 'package:childhouse/view/view_verify.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: const HomePage(),
    routes: {
      loginview: (context) => const ViewLogin(),
      registerview: (context) => const ViewRegister(),
      childhouseview: (context) => const ChildhouseView(),
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        ),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              final use = FirebaseAuth.instance.currentUser;
              if (use != null) {
                if (use.emailVerified) {
                  return const ChildhouseView();
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

enum MenuAction { logout }

class ChildhouseView extends StatefulWidget {
  const ChildhouseView({super.key});

  @override
  State<ChildhouseView> createState() => _ChildhouseViewState();
}

class _ChildhouseViewState extends State<ChildhouseView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Menu"),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final navigator = Navigator.of(context);
                  final showLogout = await showLogOutDialog(context);
                  if (showLogout) {
                    await FirebaseAuth.instance.signOut();
                    navigator.pushNamedAndRemoveUntil(
                      loginview,
                      (_) => false,
                    );
                  }
              }
            },
            itemBuilder: ((context) {
              return const [
                PopupMenuItem(value: MenuAction.logout, child: Text("Log out"))
              ];
            }),
          )
        ],
      ),
      body: const Text('Hello '),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context) {
  return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Sign out"),
          content: const Text('Are you sure you want to sign out? '),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Log Out'),
            ),
          ],
        );
      }).then((value) => value ?? false);
}


