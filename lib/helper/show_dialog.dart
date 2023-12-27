import 'package:flutter/material.dart';
import 'package:todo_calendar/firebase/firestore.dart';

class ShowDialog{
  FirestoreDB fsDB = FirestoreDB();

  void showDialogWithAddRecord(BuildContext context, TextEditingController controller, today){
    var dialogAdd = AlertDialog(
      title: Text('Add record on ${today.day}.${today.month}.${today.year}'),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(
        hintText: 'Enter name record',
        ),
        maxLength: 50,
      ),
      actions: [
        TextButton(onPressed: (){
          fsDB.addRecordNameInFirestoreDB(controller, today);
          controller.clear();
          Navigator.pop(context);
        }, 
        child: const Text('Add')
        ),

        TextButton(onPressed: (){
          controller.clear();
          Navigator.pop(context);
        }, 
        child: const Text('Close')
        )
      ],
    );

    showDialog(context: context, builder: (BuildContext context) {
      return dialogAdd;
    });
  } 

  void showDialogWithDeleteRecord(BuildContext context, document,record)
  {
    var dialogDelete = AlertDialog(
      title: Text('Are you sure you want to delete the record: $record?'),
      actions: [
        TextButton(onPressed: (){
          document.reference.delete();
          Navigator.pop(context);
        }, 
        child: const Text('Delete')),
        TextButton(onPressed: () {
          Navigator.pop(context);
        }, 
        child: const Text('Close')),
      ],
    );
    showDialog(context: context, builder: (BuildContext context){
      return dialogDelete;
    });
  }

  void showDialogWithAddRecordDescription(BuildContext context, TextEditingController controller, today){
    var dialogAddDesc = AlertDialog(
      title: Text('Add record on ${today.day}.${today.month}.${today.year}'),
      content: TextField(
        controller: controller,
        decoration: const InputDecoration(
        hintText: 'Enter description record',
        ),
        maxLength: 1000,
      ),
      actions: [
        TextButton(onPressed: (){
          fsDB.addRecordDescInFirestoreDB(controller, today);
          controller.clear();
          Navigator.pop(context);
        }, 
        child: const Text('Add')
        ),

        TextButton(onPressed: (){
          controller.clear();
          Navigator.pop(context);
        }, 
        child: const Text('Close')
        )
      ],
    );
    showDialog(context: context, builder: (BuildContext context){
      return dialogAddDesc;
    });
  }

}