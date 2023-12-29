import 'package:flutter/material.dart';
import 'package:todo_calendar/firebase/firestore.dart';

class ShowDialog{
  FirestoreDB fsDB = FirestoreDB();

  void showDialogWithAddRecord(BuildContext context, TextEditingController controller, today){
    var dialogAdd = AlertDialog(
      backgroundColor: Colors.grey[800],
      title: Text('Add record on ${today.day}.${today.month}.${today.year}', style: const TextStyle(color: Colors.white),),
      content: TextField(
        controller: controller,
        cursorColor: const Color.fromARGB(255, 77, 150, 122),
        decoration: const InputDecoration(
          hintText: 'Enter name record', hintStyle: TextStyle(color: Colors.grey,),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 77, 150, 122))),
        ),
        style: const TextStyle(fontSize: 18, color: Colors.white,),
        maxLines: null,
        maxLength: 50,
      ),
      actions: [
        TextButton(onPressed: (){
          fsDB.addRecordNameInFirestoreDB(controller, today);
          controller.clear();
          Navigator.pop(context);
        }, 
        child: const Text('Add', style: TextStyle(color: Color.fromARGB(255, 77, 150, 122)))
        ),

        TextButton(onPressed: (){
          controller.clear();
          Navigator.pop(context);
        }, 
        child: const Text('Close', style: TextStyle(color: Color.fromARGB(255, 77, 150, 122)))
        )
      ],
    );

    showDialog(context: context, builder: (BuildContext context) {
      return dialogAdd;
    });
  } 

  void showDialogWithDeleteRecord(BuildContext context, document, recordName)
  {
    var dialogDelete = AlertDialog(
      backgroundColor: Colors.grey[800],
      title: Text('Are you sure you want to delete the record: $recordName?', style: const TextStyle(color: Colors.white)),
      actions: [
        TextButton(onPressed: (){
          document.reference.delete();
          Navigator.pop(context);
        }, 
        child: const Text('Delete', style: TextStyle(color: Color.fromARGB(255, 77, 150, 122)))),
        TextButton(onPressed: () {
          Navigator.pop(context);
        }, 
        child: const Text('Close', style: TextStyle(color: Color.fromARGB(255, 77, 150, 122)))),
      ],
    );
    showDialog(context: context, builder: (BuildContext context){
      return dialogDelete;
    });
  }

}