// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_calendar/firebase/auth.dart';
import 'package:todo_calendar/screen/Registration.dart';
import 'package:todo_calendar/screen/home.dart';

class AuthorizationScreen extends StatefulWidget {
  const AuthorizationScreen({super.key});

  @override
  State<AuthorizationScreen> createState() => _AuthorizationScreenState();
}

class _AuthorizationScreenState extends State<AuthorizationScreen>
    with SingleTickerProviderStateMixin {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FirebaseAuthentication fbAuth = FirebaseAuthentication();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(colors: [
          Color.fromARGB(255, 241, 228, 114),
          Color.fromARGB(255, 114, 241, 209)
        ],begin: Alignment.topCenter, end: Alignment.bottomCenter
        )),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: MediaQuery.sizeOf(context).height/50),
              padding: EdgeInsets.all(MediaQuery.sizeOf(context).aspectRatio*15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.0),
                border: Border.all(color: Colors.black),
                color: Colors.transparent 
              ),
              child: const Text('Sign In', style: TextStyle(fontSize: 24),)
            ),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.sizeOf(context).width/60),
              padding: const EdgeInsets.all(10),
              child: Column(
                mainAxisAlignment:  MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: MediaQuery.sizeOf(context).height/90),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      border: Border.all(color: Colors.black), 
                    ),
                    child: TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText:'enter email',
                        prefixIcon: Icon(Icons.email)
                      ),
                    ),
                  ),

                  Container(
                    margin: EdgeInsets.only(bottom: MediaQuery.sizeOf(context).height/90),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      border: Border.all(color: Colors.black),
                    ),
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText:'enter password',
                        prefixIcon: Icon(Icons.lock),
                      ),
                    ),
                  ),

                  OutlinedButton(onPressed: (){signIn();},
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                      side: MaterialStateProperty.all<BorderSide>(const BorderSide(color: Colors.black)),
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                    ), 
                    child: const Text('enter', style: TextStyle(fontSize: 16),),
                    ),

                 
                ],
              ),
            ),
             Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('no accaunt?'),
                TextButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const RegistrationScreen()));
                }, 
                child: const Text('Register'))
              ],
            )
          ],
        ),
      ),
    );
  }

  void signIn() async{
    String email = emailController.text;
    String password = passwordController.text;

    User? user = await fbAuth.signInWithEmailAndPawword(email, password, context);
    if(user != null){
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeScreen()), (route) => false);
    }
  }
}