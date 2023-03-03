import 'package:childhouse/view/view_login.dart';
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
  ));

}
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:  AppBar(title: const Text("Home Page"),),
       body: FutureBuilder(
          future:  Firebase.initializeApp( 
              options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState){
              case ConnectionState.done:
                final use=  FirebaseAuth.instance.currentUser;
                if(use?.emailVerified?? false){
                  return Text("Done");
                } else{
                  return const VerifyEmailView();
                }
                default : return const Text("Loading....");
            } 
          }
        ),

    );
  }
}

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return  Column(children: [
          const Text("Please verify  your email address "),
          TextButton(onPressed: (() async {
             final use = FirebaseAuth.instance.currentUser;
             await use?.sendEmailVerification();
            
          }), child: const Text("Send email verification"))
      ]);
  }
}






class ViewRegister extends StatefulWidget {
  const ViewRegister({super.key});

  @override
  State<ViewRegister> createState() => _ViewRegisterState();
}

class _ViewRegisterState extends State<ViewRegister> {
  late final TextEditingController  _email;
  late  final TextEditingController  _password;

  @override
  void initState() {
    _email= TextEditingController();
    _password= TextEditingController();
    
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
       );
  }
}
