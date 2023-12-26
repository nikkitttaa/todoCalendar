import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  TextEditingController recordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

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
          addDataInFirestoreDB();
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

  void addDataInFirestoreDB(){

    String record = recordController.text;

    int year = today.year;
    int month = today.month;
    int day = today.day;

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


    CollectionReference recordsCollection = FirebaseFirestore.instance
    .collection('recordsCollection')
    .doc('$year year')
    .collection(monthName)
    .doc('$day days').collection('$day days');

    recordsCollection.add({'record':record}).then((value){
      recordController.clear();
    });
  }
}