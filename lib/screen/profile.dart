import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
     
  String avatarUrl = 'https://avatars.mds.yandex.net/i?id=c071b869a097dc08c30888218ef0be928a7e2bdd-5251929-images-thumbs&n=13';
  String username = 'username';
  int addRecord = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(avatarUrl),
              ),
              Text(username, style: const TextStyle(fontSize: 20),)
            ],
          ),
          ),
          const Text('Stats', style: TextStyle(fontSize: 32),),
          Container(
            margin: const EdgeInsets.all(10),
            child: Row(
              children: [
                const Text('add record: ', style: TextStyle(fontSize: 20),),
                Text(addRecord.toString(), style: const TextStyle(fontSize: 20),)
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: Row(
              children: [
                const Text('write letter: ', style: TextStyle(fontSize: 20),),
                Text(addRecord.toString(), style: const TextStyle(fontSize: 20),)
              ],
            ),
          )
        ],
      ),
    );
  }
  
}