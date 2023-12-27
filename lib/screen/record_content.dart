import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_calendar/firebase/firestore.dart';
import 'package:todo_calendar/helper/show_dialog.dart';

// ignore: must_be_immutable
class RecordScreen extends StatelessWidget {

  FirestoreDB fsDB = FirestoreDB();
  ShowDialog sd = ShowDialog();
  
  TextEditingController controller  =TextEditingController();

  final DateTime today;

  RecordScreen({super.key, required this.today});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Record on $today'),
      ),
      body: Expanded(
        child: StreamBuilder<QuerySnapshot>(
          stream: fsDB.getStream(today),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text('Ошибка: ${snapshot.error}');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Text('Loading..');
            }

            return ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> recordData = document.data() as Map<String, dynamic>;
                String recordName = recordData['recordName'];
                String? recordDesc = recordData['recordDesc'];
                String? desc = recordDesc;
                desc ??= 'not found desc';
                
            return Container(
              margin: const EdgeInsets.only(left: 5, right: 5, top: 5),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.blue),
              child: ListTile(
                title: Text(recordName),  
                subtitle: Text(desc),
                trailing: IconButton(
                  onPressed: () {
                    sd.showDialogWithAddRecordDescription(context, controller, today);
                  },
                  icon: const Icon(Icons.edit),),
                ),
              );
              }).toList(),
            );
          },
        )
      )
    );
  }
}