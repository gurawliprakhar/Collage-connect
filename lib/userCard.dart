import 'package:alpha/screens/chatTabs/chatModel.dart';
import 'package:alpha/screens/chatTabs/individualChatPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserCard extends StatefulWidget {
  const UserCard({Key? key, required this.user}) : super(key: key);

  final ChatModel user;

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print(widget.user.imageUrl);
        print(widget.user.name);
        print(widget.user.studentId);
        print(widget.user.course);
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (_) => IndividualChatPage(
              chatModel: widget.user,
            ),
          ),
        );
      },
      child: ListTile(
        leading: const CircleAvatar(
          radius: 23,
          child: Icon(
            Icons.person_sharp,
            size: 30,
          ),
        ),
        title: Text(
          widget.user.name,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          '${widget.user.course}  ${widget.user.branch}  ${widget.user.year}',
          style: const TextStyle(fontSize: 13),
        ),
      ),
    );
  }
}
