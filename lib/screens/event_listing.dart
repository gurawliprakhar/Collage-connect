import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class EventListing extends StatefulWidget {
  const EventListing({Key? key}) : super(key: key);

  @override
  State<EventListing> createState() => _EventListingState();
}

class _EventListingState extends State<EventListing> {
  final _firestore = FirebaseFirestore.instance;

  Constants c = Constants();
  TextEditingController eventName = TextEditingController();
  TextEditingController eventDate = TextEditingController();
  TextEditingController eventTime = TextEditingController();

  void addEvent() {
    var time = DateTime.now().toString();
    time = time.replaceAll('-', '');
    time = time.replaceAll(':', '');
    time = time.replaceAll(' ', '');
    time = time.replaceAll('.', '');

    _firestore.collection('events').doc(time).set({
      'Event Name': eventName.text,
      'Date Time': eventDate.text,
      'Location': eventTime.text
    });
    eventName.clear();
    eventDate.clear();
    eventTime.clear();

    showInSnackBar(value: 'Event set Successfully', context: context);
  }

  void showInSnackBar({required String value, required BuildContext context}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(value,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 20, color: Colors.white)),
      duration: const Duration(seconds: 2),
      behavior: SnackBarBehavior.fixed,
      elevation: 5.0,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Events Listing'),
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 50,
          ),
          textField(title: 'Event Name', controller: eventName),
          textField(title: 'Date / Time', controller: eventDate),
          textField(title: 'Location', controller: eventTime),
          const SizedBox(
            height: 80,
          ),
          Center(
            child: InkWell(
              onTap: () {
                if (eventName.text.trim().isEmpty) {
                  showInSnackBar(
                      value: 'Please enter event name', context: context);
                } else if (eventDate.text.trim().isEmpty) {
                  showInSnackBar(
                      value: 'Please enter the date', context: context);
                } else if (eventTime.text.trim().isEmpty) {
                  showInSnackBar(
                      value: 'Please enter the time', context: context);
                } else {
                  addEvent();
                }
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.center,
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [Color(0xFF3739A6), Color(0xFF8B4FE3)]),
                    borderRadius: BorderRadius.circular(20)),
                child: const Text(
                  'Set Event',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget textField(
    {required String title, required TextEditingController controller}) {
  bool hide = true;
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      // decoration: BoxDecoration(
      //     color: Colors.white.withOpacity(0.5),
      //     borderRadius: BorderRadius.circular(20)),
      child: StatefulBuilder(builder: (ctx, setState) {
        return TextField(
          controller: controller,
          keyboardType: TextInputType.text,
          style: const TextStyle(fontSize: 18),
          decoration: InputDecoration(
            // border: OutlineInputBorder(borderSide: BorderSide()),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.cyan, width: 2),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2),
            ),
            labelText: title,
            labelStyle: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
            hintStyle: const TextStyle(fontSize: 18),
          ),
        );
      }),
    ),
  );
}
