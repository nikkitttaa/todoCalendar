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

  CalendarFormat calendarFormat = CalendarFormat.week;
  void onFormatButtonPressed() {
    setState(() {
      calendarFormat = (calendarFormat == CalendarFormat.week)
        ? CalendarFormat.month
        : CalendarFormat.week;
           
    });
  }

  CollectionReference recordsCollection = FirebaseFirestore.instance.collection('recordsCollection');
  TextEditingController recordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text('todo calendar'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 77, 150, 122), 
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
            rowHeight: MediaQuery.sizeOf(context).height/22,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarFormat: calendarFormat,
            onFormatChanged: (format) {
              onFormatButtonPressed();
            },

            headerStyle: const HeaderStyle(
              formatButtonVisible: true, 
              titleCentered: true, 
              titleTextStyle: TextStyle(color: Colors.white, fontSize: 18),
              formatButtonTextStyle: TextStyle(color: Colors.white, ), 
              ),

            calendarStyle: const CalendarStyle(selectedDecoration: BoxDecoration(
              color: Color.fromARGB(255, 77, 150, 122), shape: BoxShape.circle),
              todayDecoration: BoxDecoration(color: Color.fromARGB(255, 40, 61, 54), shape: BoxShape.circle),
              defaultTextStyle: TextStyle(color: Colors.white)
              ),
              
            ),
            
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: fsDB.getStream(today),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Text('Loading..');
                }
                if (snapshot.hasData) {
                return ListView(
                  children: snapshot.data!.docs.map((DocumentSnapshot document) {
                  Map<String, dynamic> record = document.data()! as Map<String, dynamic>;
                    return Container(
                      margin: const EdgeInsets.all(5),
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: const Color.fromARGB(255, 77, 150, 122)),
                      child: ListTile(
                        title: Text(record['recordName']),
                        trailing: IconButton(onPressed: (){
                          sd.showDialogWithDeleteRecord(context, document, record['recordName']);
                        }, 
                        icon: const Icon(Icons.delete)),
                        onTap: () {
                          String documentId = fsDB.getDocumentID(document);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => RecordScreen(today: today, documentId: documentId,)));
                        },
                      ),
                    );
                  }).toList(),
                );
              }
               return const Text('Нет данных');
            }
          )
        )
        ],
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        sd.showDialogWithAddRecord(context,recordController,today);
      }, 
      backgroundColor: const Color.fromARGB(255, 77, 150, 122),
      child: const Icon(Icons.add, color: Colors.white,),
      
      ),
    );
    
  }

}