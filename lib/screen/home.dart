import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_calendar/firebase/firestore.dart';
import 'package:todo_calendar/helper/show_dialog.dart';
import 'package:todo_calendar/screen/record_content.dart';

FirestoreDB fsDB = FirestoreDB();
ShowDialog sd = ShowDialog();

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
  
class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {

  DateTime today = DateTime.now();
  CalendarFormat format = CalendarFormat.week;

  void selectedDayFunc(DateTime day, DateTime focusedDay){
    setState(() {
      today = day;
    });
  }

  bool foramtIsWeek = true;

  void headerTappedFunc(focusedDay){
    setState(() {
      foramtIsWeek = !foramtIsWeek;
      if(foramtIsWeek == true) {
        format = CalendarFormat.week;
        }
      else {format = CalendarFormat.month;}
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
        backgroundColor: Colors.blue, 
      ),
      body: Column(
        children: [
          TableCalendar(
            locale: 'ru_RU',
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
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarFormat: format,
            onHeaderTapped: (focusedDay) => headerTappedFunc(focusedDay),
            ),
            
          Expanded(
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
                    
                return Container(
                  margin: const EdgeInsets.only(left: 5, right: 5, top: 5),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.blue),
                  child: GestureDetector(
                    child: ListTile(
                      title: Text(recordName),  
                      trailing: IconButton(
                        onPressed: () {
                          sd.showDialogWithDeleteRecord(context, document, recordName);
                        },
                        icon: const Icon(Icons.delete),),
                      ),
                      onTap: (){
                        Navigator.push(context, 
                        MaterialPageRoute(builder: ((context) =>  RecordScreen(today: today))));
                      }
                    )
                  );
                  }).toList(),
                );
              },
            )
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        sd.showDialogWithAddRecord(context,recordController,today);
      }, 
      backgroundColor: Colors.deepPurpleAccent,
      child: const Icon(Icons.add, color: Colors.white,),
      
      ),
    );
    
  }

}