import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:alpha/screens/event_listing.dart';

class Event extends StatefulWidget {
  const Event({Key? key}) : super(key: key);

  @override
  State<Event> createState() => _EventState();
}

class _EventState extends State<Event> {
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              CupertinoPageRoute(builder: (_) => const EventListing()));
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('events').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            );
          }
          final messages = snapshot.data?.docs;
          List<MessageBubble> messageBubbles = [];
          for (var message in messages!) {
            final eventName = message['Event Name'];
            final dateTime = message['Date Time'];
            final loction = message['Location'];

            final messageBubble = MessageBubble(
              name: eventName,
              dateTime: dateTime,
              location: loction,
            );
            messageBubbles.add(messageBubble);
          }
          return ListView(
            shrinkWrap: true,
            reverse: true,
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            children: messageBubbles,
          );
        },
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble(
      {super.key,
      required this.name,
      required this.dateTime,
      required this.location});

  final String name;
  final String dateTime;
  final String location;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          alignment: Alignment.center,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Image.asset(
              "assets/event_icon.png",
              fit: BoxFit.cover,
            ),
            title: Text(
              name,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Date/Time:  $dateTime',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              'Location:  $location',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const Divider(
          height: 2,
          thickness: 2,
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
