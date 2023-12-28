// ignore_for_file: must_be_immutable, no_logic_in_create_state, prefer_const_declarations

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_calendar/firebase/firestore.dart';
import 'package:todo_calendar/helper/show_dialog.dart';


class RecordScreen extends StatefulWidget {
RecordScreen({super.key, required this.today, required this.documentId});

  String documentId;
  DateTime today;
  
  @override
  State<RecordScreen> createState() => _RecordScreenState(today: today, documentId: documentId);
}

class _RecordScreenState extends State<RecordScreen>
    with SingleTickerProviderStateMixin {
  _RecordScreenState({required this.today, required this.documentId});

  FirestoreDB fsDB = FirestoreDB();
  ShowDialog sd = ShowDialog();
  String documentId;
  DateTime today;
  
  late TextEditingController descController;
  late TextEditingController nameController;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text('Description'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 77, 150, 122),
        actions: [
          IconButton(onPressed: (){
            fsDB.updateRecord(descController, today, nameController);
            final saveInfoBar = const SnackBar(
              content: Text('Record has been saved!', style: TextStyle(fontSize: 16)),
              duration: Duration(seconds: 3),
              backgroundColor: Color.fromARGB(255, 77, 150, 122),
              showCloseIcon: true,
            );
            ScaffoldMessenger.of(context).showSnackBar(saveInfoBar);
          },  
            icon: const Icon(Icons.save))
        ],
      ),
      body: ListView(
        children: [
          Expanded(
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('recordsCollection')
                  .doc('${today.year} year')
                  .collection(fsDB.monthName(today.month))
                  .doc('${today.day} days')
                  .collection('${today.day} days')
                  .doc(documentId)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('error: ${snapshot.error}'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child:Text('Loading..')
                  );
                }

                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(
                    child: Text('Doc not found'),
                  );
                }

                final record = snapshot.data!.data() as Map<String, dynamic>;
                descController = TextEditingController(text: record['recordDesc']);
                nameController = TextEditingController(text: record['recordName']);
                return ListTile(
                  title: TextField(
                    controller: nameController,
                    cursorColor: const Color.fromARGB(255, 77, 150, 122),
                    decoration: const InputDecoration(labelText: 'Name record', 
                      floatingLabelStyle : TextStyle(color: Color.fromARGB(255, 77, 150, 122)),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 77, 150, 122))),
                    ),
                    style: const TextStyle(fontSize: 28, color: Colors.white,),
                    maxLength: 50,
                    maxLines: null,
                  ),
                  subtitle: TextField(
                    controller: descController,
                    cursorColor: const Color.fromARGB(255, 77, 150, 122),
                    decoration: const InputDecoration(labelText: 'Descripton record', 
                      floatingLabelStyle : TextStyle(color: Color.fromARGB(255, 77, 150, 122)),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color.fromARGB(255, 77, 150, 122))),
                    ),
                    style: const TextStyle(fontSize: 18, color: Colors.white,),
                    maxLines: null,
                    maxLength: 1000,
                  ),
                  );
              },
            ),
          )
        ],
      )
    );
  }
  
}