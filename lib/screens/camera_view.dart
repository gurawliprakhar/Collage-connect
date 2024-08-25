import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraViewPage extends StatelessWidget {
  CameraViewPage({Key? key, required this.picture}) : super(key: key);

  var picture;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 150,
              child: Image.file(
                XFile(picture) as File,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                color: Colors.black38,
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                child: TextFormField(
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                  maxLines: 6,
                  minLines: 1,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Add Caption',
                    hintStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                    ),
                    suffixIcon: CircleAvatar(
                      backgroundColor: Colors.tealAccent[800],
                      radius: 95,
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 27,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
