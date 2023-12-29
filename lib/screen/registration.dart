// ignore_for_file: file_names, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_calendar/firebase/auth.dart';
import 'package:todo_calendar/screen/home.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen>
    with SingleTickerProviderStateMixin {

  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  FirebaseAuthentication fbAuth = FirebaseAuthentication();

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 241, 218, 114),
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back_ios),)
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: LinearGradient(colors: [
          Color.fromARGB(255, 241, 218, 114),
          Color.fromARGB(255, 114, 169, 241)
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
              child: const Text('Registration', style: TextStyle(fontSize: 24),)
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
                      controller: usernameController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText:'enter username',
                        prefixIcon: Icon(Icons.lock),
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

                  Container(
                    margin: EdgeInsets.only(bottom: MediaQuery.sizeOf(context).height/90),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      border: Border.all(color: Colors.black),
                    ),
                    child: TextField(
                      controller: confirmPasswordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText:'confirm password',
                        prefixIcon: Icon(Icons.lock),
                      ),
                    ),
                  ),

                  OutlinedButton(onPressed: (){createUser();},
                    style: ButtonStyle(
                      foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                      side: MaterialStateProperty.all<BorderSide>(const BorderSide(color: Colors.black)),
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
                    ), 
                    child: const Text('register', style: TextStyle(fontSize: 16),),
                    ),
                ],
              ),
            ),
             const Row()
          ],
        ),
      ),
    );
  }

  void createUser() async {
    String username = usernameController.text;
    String email = emailController.text;
    String password = passwordController.text;
    String confirmPassword = confirmPasswordController.text;

    User? user = await fbAuth.createUserWithEmailAndPawword(username, email, password, confirmPassword, context);
    if(user != null){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeScreen()), (route) => false);
    }
  }
}