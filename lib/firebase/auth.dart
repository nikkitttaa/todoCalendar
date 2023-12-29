// ignore_for_file: avoid_print
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseAuthentication{

  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<User?> createUserWithEmailAndPawword(String username, String email, String password, String confirmPassword ,context) async{
    bool isSaved = false;
    String errorMessage = '';
    late int count;

    try{
      if (username.isEmpty || email.isEmpty || password.length < 6 || confirmPassword != password){
        isSaved = false;
        if (username.isEmpty) { count = 1; } 

        else if (email.isEmpty){ count = 2;}

        else if (password.length < 6){ count = 3;}

        else if (confirmPassword != password){ count = 4;}

        switch(count){
          case 1:
            errorMessage = 'Введите логин';
          break;
          case 2:
            errorMessage = 'Введите почту';
          break;
          case 3:
            errorMessage = 'Пароль должен содержать минимум 6 символов';
          break;
          case 4:
            errorMessage = 'Пароли не совпадают. Повторите попытку';
          break;
          default:
        }
        final errorInfoBar = SnackBar(
              content: Text(errorMessage, style: const TextStyle(fontSize: 16)),
              duration: const Duration(seconds: 6),
              backgroundColor: Colors.red,
              showCloseIcon: true,
              behavior: SnackBarBehavior.floating,
            );
            ScaffoldMessenger.of(context).showSnackBar(errorInfoBar);
        
      }
      else{
          isSaved = true;
      }
      if (isSaved == true){
          UserCredential credential = await auth.createUserWithEmailAndPassword(email: email, password: password);
          return credential.user;
      }
      else{
          errorMessage = 'Зарегистрироваться не удалось :(';
      }
    }
    on FirebaseAuthException catch(error){
      print('\u001b[31m$error');

      String errorMessage;

      switch (error.code) {
      case 'weak-password':
          errorMessage = 'Слабый пароль';
        break;
      case 'email-already-in-use':
          errorMessage = 'Этот email уже зарегистрирован';
        break;
      default:
          errorMessage = 'Произошла ошибка при регистрации';
      }

       final errorInfoBar = SnackBar(
              content: Text(errorMessage, style: const TextStyle(fontSize: 16)),
              duration: const Duration(seconds: 6),
              backgroundColor: Colors.red,
              showCloseIcon: true,
              behavior: SnackBarBehavior.floating,
            );
            ScaffoldMessenger.of(context).showSnackBar(errorInfoBar);
    }
      return null;
  }



  Future<User?> signInWithEmailAndPawword(String email, String password, context) async{
    try{
      UserCredential credential = await auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user;
    }
    on FirebaseAuthException catch(error){
      print('\u001b[31m$error');
       
      String errorMessage;
  
      switch (error.code) {
        case 'invalid-credential':
          errorMessage = 'Предоставленные учетные данные для авторизации неверны, неправильно сформированы или срок их действия истек.';
          break;
        case 'invalid-email':
          errorMessage = 'Некорректный email.';
          break;
        case 'user-disabled':
          errorMessage = 'Учетная запись пользователя была отключена администратором.';
          break;
          case 'too-many-requests':
          errorMessage = 'Мы заблокировали все запросы с этого устройства из-за необычной активности. Попробуйте еще раз позже.';
          break;
        default:
          errorMessage = 'Произошла ошибка при входе в систему.';
          break;
      }

      final errorInfoBar = SnackBar(
              content: Text(errorMessage, style: const TextStyle(fontSize: 16)),
              duration: const Duration(seconds: 6),
              backgroundColor: Colors.red,
              showCloseIcon: true,
              behavior: SnackBarBehavior.floating,
            );
            ScaffoldMessenger.of(context).showSnackBar(errorInfoBar);
    }
      return null;
  }

}