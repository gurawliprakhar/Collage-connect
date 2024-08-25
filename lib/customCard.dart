import 'package:alpha/screens/chatTabs/chatModel.dart';
import 'package:alpha/screens/chatTabs/individualChatPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({Key? key, required this.chatModel}) : super(key: key);
  final ChatModel chatModel;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (_) => IndividualChatPage(
              chatModel: chatModel,
            ),
          ),
        );
      },
      child: Column(
        children: [
          ListTile(
            leading: const CircleAvatar(
              radius: 30,
              child: Icon(
                Icons.person_sharp,
                size: 35,
              ),
            ),
            title: Text(
              chatModel.name,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            subtitle: Row(children: [
              const Icon(Icons.done_all),
              const SizedBox(
                width: 10,
              ),
              Text(chatModel.currentMessage),
            ]),
            trailing: Text(chatModel.timer),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 20, left: 80),
            child: Divider(
              thickness: 1,
            ),
          )
        ],
      ),
    );
  }
}
