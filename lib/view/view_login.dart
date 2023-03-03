import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../firebase_options.dart';

class ViewLogin extends StatefulWidget {
  const ViewLogin({super.key});

  @override
  State<ViewLogin> createState() => _ViewLoginState();
}

class _ViewLoginState extends State<ViewLogin> {
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
          title: const Text('Login'),
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
                      await FirebaseAuth.instance.signInWithEmailAndPassword(
                        email: email,
                        password: password,
                        );
                      print(Credential);
                      } on FirebaseAuthException catch(e){
                        if(e.code=="user-not-found"){
                            print("User not found");
                        } else if(e.code=="wrong-password") {
                          print("Wrong password");
                        } else if(e.code== "invalid-email"){
                          print("Invalid email");
                        }
                          
                      }
                      
                    }, child: const Text("Login"))
                  ],
                );
                default : return const Text("Loading....");
            } 
          }
        ));
  }
}