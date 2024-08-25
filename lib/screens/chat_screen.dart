import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:alpha/constant2.dart';

final _firestore = FirebaseFirestore.instance;
var loggedInUser;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  // static String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String studentId = '';
  String name = '';

  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        title: const Text('Discussion'),
        backgroundColor: Colors.lightBlue[800],
      ),
      body: SafeArea(
        child: Container(
          color: Colors.blue[50],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              MessagesStream(
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
                        _firestore.collection('messages').doc(time).set({
                          'text': messageText,
                          'sender': name,
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
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  const MessagesStream({super.key, this.name});

  final name;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').snapshots(),
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
            sender: messageSender,
            text: messageText,
            isMe: name == messageSender,
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
              color: Colors.black54,
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
