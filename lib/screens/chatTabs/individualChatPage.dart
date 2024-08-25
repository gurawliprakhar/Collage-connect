import 'package:alpha/screens/camera_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../constant2.dart';
// import '../chat_screen.dart';
import 'chatModel.dart';

final _firestore = FirebaseFirestore.instance;
var loggedInUser;

class IndividualChatPage extends StatefulWidget {
  const IndividualChatPage({Key? key, required this.chatModel})
      : super(key: key);

  final ChatModel chatModel;

  @override
  State<IndividualChatPage> createState() => _IndividualChatPageState();
}

class _IndividualChatPageState extends State<IndividualChatPage> {
  // String loggedInUserStudentId = '';
  String studentId = '';
  String name = '';
  // String rollNo = '';
  // String email = '';
  // String contact = '';
  // String branch = '';
  // String course = '';
  // String imageUrl = '';
  // String year = '';
  // String dob = '';
  // String gender = '';

  bool show = false;
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  late String studentId2;

  late String messageText;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }

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
                  // rollNo = s['University Roll No'];
                  // contact = s['Contact'];
                  // course = s['Course'];
                  // branch = s['Branch'];
                  // imageUrl = s['ImageUrl'].toString();
                  // year = s['Year'];
                  // gender = s['Gender'];
                  // dob = s['DOB'];
                  // print(imageUrl);
                });
              }
            }));
  }

  Widget bottomSheet() {
    return Container(
      margin: const EdgeInsets.only(left: 80, right: 60, top: 60, bottom: 50),
      height: 150,
      width: 40,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        margin: const EdgeInsets.all(18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.indigo,
                    radius: 40,
                    child: InkWell(
                      onTap: () {},
                      child: const Icon(
                        Icons.photo,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Text('Gallery'),
                ]),
            const SizedBox(
              width: 20,
            ),
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.purple,
                    radius: 40,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (_) => const CameraScreen(),
                          ),
                        );
                      },
                      child: const Icon(
                        Icons.camera_alt,
                        size: 40,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const Text('Camera'),
                ]),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        leadingWidth: 70,
        titleSpacing: 0,
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back,
                size: 25,
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            const CircleAvatar(
              radius: 20,
              backgroundColor: Colors.yellow,
              child: Icon(Icons.person),
            ),
          ],
        ),
        title: Container(
          margin: const EdgeInsets.all(7),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.chatModel.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                widget.chatModel.contact,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                ),
              )
            ],
          ),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/chat_bk.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            MessagesStream(
              studentId2: widget.chatModel.studentId,
              studentId: studentId,
              name: name,
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      var time = DateTime.now().toString();
                      time = time.replaceAll('-', '');
                      time = time.replaceAll(':', '');
                      time = time.replaceAll(' ', '');
                      time = time.replaceAll('.', '');
                      messageTextController.clear();
                      _firestore.collection('personal messages').doc(time).set({
                        'text': messageText,
                        'sender': loggedInUser.email,
                      });
                    },
                    child: const Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  const MessagesStream({super.key, this.studentId2, this.studentId, this.name});

  final studentId2;
  final studentId;
  final name;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('personal messages').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages = snapshot.data?.docs.reversed;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages!) {
          final messageText = message['text'];
          final messageSender = message['sender'];

          final currentUser = loggedInUser.email;

          final messageBubble = MessageBubble(
            sender: name,
            text: messageText,
            isMe: currentUser == messageSender,
          );
          messageBubbles.add(messageBubble);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble(
      {super.key,
      required this.sender,
      required this.text,
      required this.isMe});

  final String sender;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: isMe
          ? const EdgeInsets.only(left: 10.0, top: 10.0, bottom: 10.0)
          : const EdgeInsets.only(right: 10.0, top: 10.0, bottom: 10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: const TextStyle(
              fontSize: 12.0,
              color: Colors.white,
            ),
          ),
          Material(
            borderRadius: isMe
                ? const BorderRadius.only(
                    topLeft: Radius.circular(15.0),
                    bottomLeft: Radius.circular(15.0),
                    bottomRight: Radius.circular(15.0),
                  )
                : const BorderRadius.only(
                    topRight: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0),
                    bottomRight: Radius.circular(10.0),
                  ),
            elevation: 10.0,
            color: isMe ? Colors.lightBlueAccent[400] : Colors.white,
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 15.0,
                  color: isMe ? Colors.white : Colors.black54,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
