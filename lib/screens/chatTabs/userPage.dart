import 'package:alpha/userCard.dart';
import 'package:flutter/material.dart';
import 'chatModel.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key, required this.details}) : super(key: key);

  final List details;

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  List<ChatModel> users = [];

  void userList() {
    for (int i = 0; i < widget.details.length; i++) {
      setState(() {
        users.add(ChatModel(
          name: widget.details[i]['Name'],
          course: widget.details[i]['Course'],
          year: widget.details[i]['Year'],
          branch: widget.details[i]['Branch'],
          contact: widget.details[i]['Contact'],
          imageUrl: widget.details[i]['ImageURL'].toString(),
          studentId: widget.details[i]['Student Id'],
        ));
      });
    }
    print(users);
  }

  @override
  void initState() {
    super.initState();
    userList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Select User',
                  style: TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  '${widget.details.length} Users',
                  style: const TextStyle(fontSize: 13),
                ),
              ],
            ),
            const Icon(Icons.file_copy),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) => UserCard(
          user: users[index],
        ),
      ),
    );
  }
}
