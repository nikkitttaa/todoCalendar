// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class FirestoreDB{
  late String recordName;
  void addRecordNameInFirestoreDB(TextEditingController recordController, DateTime today) async{
    recordName = recordController.text;

    int year = today.year;
    int month = today.month;
    int day = today.day;
  
    CollectionReference recordsCollection = FirebaseFirestore.instance
    .collection('recordsCollection')
    .doc('$year year')
    .collection(monthName(month))
    .doc('$day days').collection('$day days');
    
    recordsCollection.add({'recordName':recordName}).then((value){
      print('\u001b[32mrecordName added on $day.$month.$year\u001b[0m');
      recordController.clear();
    }).then((error){
      print(error);
    });

    QuerySnapshot querySnapshot = await recordsCollection.where('recordName').get();
    List<DocumentSnapshot> documents = querySnapshot.docs;

    // ignore: prefer_is_empty
    if (documents.length > 0) {
      DocumentSnapshot document = documents[0];
      String documentId = document.id;

    recordsCollection.doc(documentId).update({'recordDesc':'No data'});
    }
  }


  void updateRecord(TextEditingController recordDescController, DateTime today, 
  TextEditingController recordNameController) async{

    String recordDesc = recordDescController.text;
    String recordName = recordNameController.text;

    int year = today.year;
    int month = today.month;
    int day = today.day;
  
    CollectionReference recordsCollection = FirebaseFirestore.instance
    .collection('recordsCollection')
    .doc('$year year')
    .collection(monthName(month))
    .doc('$day days').collection('$day days');
     

    QuerySnapshot querySnapshot = await recordsCollection.where('recordName').get();
    List<DocumentSnapshot> documents = querySnapshot.docs;

    // ignore: prefer_is_empty
    if (documents.length > 0) {
      DocumentSnapshot document = documents[0];
      String documentId = document.id;

      await recordsCollection.doc(documentId).update({'recordName': recordName, 'recordDesc': recordDesc});
    }
  }
  
  Stream<QuerySnapshot<Map<String, dynamic>>> getStream(today){
    return FirebaseFirestore.instance
      .collection('recordsCollection')
      .doc('${today.year} year')
      .collection(monthName(today.month))
      .doc('${today.day} days')
      .collection('${today.day} days')
      .snapshots();
  }

  String getDocumentID(DocumentSnapshot docSnapshot) {
  String documentID = docSnapshot.id;

  return documentID;
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