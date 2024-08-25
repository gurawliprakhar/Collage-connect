import 'package:alpha/screens/chatTabs/chatPage.dart';
import 'package:alpha/screens/chatTabs/userPage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Chat extends StatefulWidget {
  const Chat({Key? key}) : super(key: key);

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> with SingleTickerProviderStateMixin {
  String studentId = '';
  String name = '';
  // String rollNo = '';
  // String email = '';
  String contact = '';
  String branch = '';
  String course = '';
  String year = '';
  String dob = '';
  String gender = '';
  String imageUrl = '';
  List details = [];
  List details2 = [];

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  var loggedInUser;

  late TabController tabController = TabController(
    length: 2,
    vsync: this,
    initialIndex: 0,
  );

  void getCurrentUserDetail() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {}

    await _firestore
        .collection('user')
        .get()
        .then((value) => value.docs.forEach((element) {
              var s = element.data();
              if (loggedInUser.email == s['Email']) {
                setState(() {
                  studentId = element.id;
                  name = s['Name'];
                  // email = s['Email'];
                  course = s['Course'];
                  branch = s['Branch'];
                  imageUrl = s['ImageUrl'].toString();
                });
              }
              setState(() {
                details.add(s);
              });

              print(details);
            }));

    // var details2 = _firestore.collection('personal chats')
    //     .doc(studentId)
    //     .get()
    // .then((value) => value.reference)
    // print(details2);
  }

  @override
  void initState() {
    super.initState();
    getCurrentUserDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Chat',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
          )
        ],
        bottom: TabBar(
          tabs: const [
            Tab(
              text: 'Chats',
            ),
            Tab(
              text: 'Users',
            )
          ],
          controller: tabController,
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          const ChatPage(),
          UserPage(
            details: details,
          ),
        ],
      ),
    );
  }
}
