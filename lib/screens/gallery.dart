import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';
import '../add_image.dart';

class Gallery extends StatefulWidget {
  const Gallery({Key? key}) : super(key: key);

  @override
  State<Gallery> createState() => _GalleryState();
}

class _GalleryState extends State<Gallery> {
  final storage = FirebaseStorage.instance;
  List<String> images = [];

  Future<void> uploadImage(String fileName, String filePath) async {
    File file = File(filePath);
    try {
      final ref = storage.ref('Gallery/$fileName');

      ref.putFile(file).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          images.add(value);
        });
      });
      print(images);
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gallery'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (_) => const AddImage(),
            ),
          );
        },
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('imageURLs').snapshots(),
        builder: (context, snapshot) {
          return !snapshot.hasData
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.green,
                  ),
                )
              : GridView.builder(
                  itemCount: snapshot.data?.docs.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemBuilder: (ctx, i) {
                    return Container(
                      margin: const EdgeInsets.all(3),
                      child: FadeInImage.memoryNetwork(
                        fit: BoxFit.cover,
                        placeholder: kTransparentImage,
                        image: snapshot.data?.docs[i].get('url'),
                      ),
                    );
                  });
        },
      ),
    );
  }
}
