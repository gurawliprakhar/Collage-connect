import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;

class AddImage extends StatefulWidget {
  const AddImage({Key? key}) : super(key: key);

  @override
  State<AddImage> createState() => _AddImageState();
}

class _AddImageState extends State<AddImage> {
  bool uploading = false;
  double val = 0;

  late CollectionReference imgRef;
  late firebase_storage.Reference ref;

  List<File> _image = [];

  final picker = ImagePicker();

  chooseImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image.add(File(pickedFile!.path));
    });
    if (pickedFile?.path == null) {
      retrieveeLostData();
    }
  }

  Future<void> retrieveeLostData() async {
    final LostData response = (await picker.retrieveLostData()) as LostData;

    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _image.add(File(response.file!.path));
      });
    } else {
      print(response.file);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    imgRef = FirebaseFirestore.instance.collection('imageURLs');
  }

  Future uploadFile() async {
    int i = 1;

    for (var img in _image) {
      setState(() {
        val = i / _image.length;
      });
      ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('Gallery/${Path.basename(img.path)}');

      await ref.putFile(img).whenComplete(() async {
        await ref.getDownloadURL().then((value) {
          imgRef.add({'url': value});
          i++;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Image'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                uploading = true;
              });
              uploadFile().whenComplete(() => Navigator.pop(context));
            },
            child: const Text(
              'Upload',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          GridView.builder(
            itemCount: _image.length + 1,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3),
            itemBuilder: (ctx, i) {
              return i == 0
                  ? Center(
                      child: IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          !uploading ? chooseImage() : null;
                        },
                      ),
                    )
                  : Container(
                      margin: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: FileImage(_image[i - 1]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    );
            },
          ),
          uploading
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Uploading...',
                        style: TextStyle(fontSize: 20),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CircularProgressIndicator(
                        value: val,
                        valueColor: const AlwaysStoppedAnimation(Colors.green),
                      )
                    ],
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
