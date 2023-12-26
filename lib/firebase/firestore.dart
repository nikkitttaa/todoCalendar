// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class FirestoreDB{
  
  void addDataInFirestoreDB(TextEditingController recordController, DateTime today){
    String record = recordController.text;

    int year = today.year;
    int month = today.month;
    int day = today.day;

    


    CollectionReference recordsCollection = FirebaseFirestore.instance
    .collection('recordsCollection')
    .doc('$year year')
    .collection(monthName(month))
    .doc('$day days').collection('$day days');
     
    recordsCollection.add({'record':record}).then((value){
      print('\u001b[32mdata added on $day.$month.$year\u001b[0m');
      recordController.clear();
    }).then((error){
      print(error);
    });
  }

  String monthName(month){
    late String monthName;

     switch(month){
      case 1: monthName = 'Январь';
      case 2: monthName = 'Февраль';
      case 3: monthName = 'Март';
      case 4: monthName = 'Апрель';
      case 5: monthName = 'Май';
      case 6: monthName = 'Июнь';
      case 7: monthName = 'Июль';
      case 8: monthName = 'Август';
      case 9: monthName = 'Сентябрь';
      case 10: monthName = 'Октябрь';
      case 11: monthName = 'Ноябрь';
      case 12: monthName = 'Декабрь';
    }

    return monthName;
  }

}