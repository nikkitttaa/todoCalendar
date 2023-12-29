import 'package:flutter/material.dart';
import 'package:todo_calendar/screen/authorization.dart';
import 'package:todo_calendar/screen/home.dart';

class LandingScreen extends StatelessWidget {
  const LandingScreen({super.key});

  final bool isLogged = false;
  @override
  Widget build(BuildContext context) {
    return isLogged? const HomeScreen()  : const AuthorizationScreen();
  }
}