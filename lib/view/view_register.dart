import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../firebase_options.dart';

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
        body: FutureBuilder(
          future:  Firebase.initializeApp( 
              options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState){
              case ConnectionState.done:
                return  Column(
                  children: [
                    TextField(
                      controller: _email,
                      enableSuggestions: false,
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        hintText: "Write your Email"
                      ),
                    ),
                    TextField(
                      controller: _password,
                      enableSuggestions: false,
                      autocorrect: false,
                      obscureText: true,
                      decoration: const InputDecoration(
              
                        hintText: "Write your Password"
                      ),
                    ),
                    TextButton(onPressed:  () async {
                      try{
                      final email= _email.text;
                      final password = _password.text;
                      final Credential =
                      await FirebaseAuth.instance.createUserWithEmailAndPassword(
                        email: email,
                        password: password,
                        );
                      print(Credential);
                      } on FirebaseAuthException catch(e){
                        if(e.code=="invalid-email"){
                          print("invalid-email");
                        } else  if(e.code== "weak-password") {
                          print("weak password");
                        } else if(e.code == "email-already-in-use") {
                          print("email is used ");
                        }
                      }
                      
                    }, child: const Text("Resgiter"))
                  ],
                );
                default : return const Text("Loading....");
            } 
          }
        ));
  }
}
