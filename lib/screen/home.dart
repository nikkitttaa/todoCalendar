import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_calendar/firebase/firestore.dart';

FirestoreDB fsDB = FirestoreDB();
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
  
class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {

  DateTime today = DateTime.now();

  void selectedDayFunc(DateTime day, DateTime focusedDay){
    setState(() {
      today = day;
    });
  }
  CollectionReference recordsCollection = FirebaseFirestore.instance.collection('recordsCollection');
  TextEditingController recordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('todo calendar'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: today, 
            firstDay: DateTime.utc(2020), 
            lastDay: DateTime.utc(2030),
            onDaySelected: selectedDayFunc,
            selectedDayPredicate: (day) => isSameDay(day, today),
            rowHeight: 40,
            headerStyle: const HeaderStyle(
              formatButtonVisible: false, 
              titleCentered: true, 
              ),
            ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('recordsCollection')
                  .doc('${today.year} year')
                  .collection(fsDB.monthName(today.month))
                  .doc('${today.day} days')
                  .collection('${today.day} days')
                  .snapshots(),
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
                    String recordText = recordData['record'];

                  
                return ListTile(
                tileColor: Colors.blue,
                title: Text(recordText),  
                trailing: IconButton(
                  onPressed: () {
                    document.reference.delete();
                  },
                  icon: const Icon(Icons.delete)),
                );
  
                  }).toList(),
                );
              },
            )
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        showDialogWithAddData(context);
      }, 
      backgroundColor: Colors.deepPurpleAccent,
      child: const Icon(Icons.add, color: Colors.white,),
      
      ),
    );
    
  }

  void showDialogWithAddData(BuildContext context){
    var dialog = AlertDialog(
      title: Text('Add record on ${today.day}.${today.month}.${today.year}'),
      content: TextField(
        controller: recordController,
        decoration: const InputDecoration(
        hintText: 'Enter record',
        ),
      ),
      actions: [
        TextButton(onPressed: (){
          fsDB.addDataInFirestoreDB(recordController, today);
          recordController.clear();
          Navigator.pop(context);
        }, 
        child: const Text('Add')
        ),

        TextButton(onPressed: (){
          recordController.clear();
          Navigator.pop(context);
        }, 
        child: const Text('Close')
        )
      ],
    );

    showDialog(context: context, builder: (BuildContext context) {
      return dialog;
    });
  } 
  
}