import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String studentId = '';
  String name = '';
  String rollNo = '';
  String email = '';
  String contact = '';
  String branch = '';
  String course = '';
  String year = '';
  String dob = '';
  String gender = '';
  List<String> details = [];

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  var loggedInUser;

  bool fetch = false;

  final _storage = FirebaseStorage.instance;
  late String fileName;
  late String filePath;
  String imageUrl = '';
  var uploadPath;

  Future<void> uploadImage() async {
    File file = File(filePath);
    try {
      Reference reference = _storage.ref().child('Profile').child(studentId);
      UploadTask uploadTask = reference.putFile(file);

      showInSnackBar(value: "Profile photo changed", context: context);

      await uploadTask.whenComplete(() async {
        uploadPath = await uploadTask.snapshot.ref.getDownloadURL();
      });

      if (uploadPath.isNotEmpty) {
        _firestore.collection('user').doc(studentId).update({
          "ImageUrl": uploadPath,
        }).then((value) => null);
      }
    } catch (e) {}
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
  void initState() {
    super.initState();
    getCurrentUserDetail();
  }

  void getCurrentUserDetail() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {}

    await _firestore
        .collection('user')
        .get()
        .then((value) => value.docs.forEach((element) {
              var s = element.data();
              if (loggedInUser.email == s['Email']) {
                setState(() {
                  studentId = element.id;
                  name = s['Name'];
                  email = s['Email'];
                  rollNo = s['University Roll No'];
                  contact = s['Contact'];
                  course = s['Course'];
                  branch = s['Branch'];
                  year = s['Year'];
                  gender = s['Gender'];
                  dob = s['DOB'];
                  imageUrl = s['ImageUrl'].toString();
                  fetch = true;
                  // print(imageUrl);

                  details = [
                    'Student Id:  $studentId',
                    'Name:  $name',
                    'Email:  $email',
                    'University RollNo:  $rollNo',
                    'Contact:  $contact',
                    'Course:  $course',
                    'Branch:  $branch',
                    'Year:  $year',
                    'DOB:  $dob',
                    'Gender:  $gender'
                  ];
                });
              }
            }));
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SizedBox(
        height: size.height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 0,
              child: Container(
                height: 260,
                width: size.width,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30)),
                  image: DecorationImage(
                      image: AssetImage('assets/img bk.jpg'),
                      fit: BoxFit.cover),
                ),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 60,
                    ),
                    CircleAvatar(
                      radius: 55,
                      child: imageUrl == 'null' || fetch == false
                          ? Image.asset(
                              "assets/profile.png",
                              fit: BoxFit.cover,
                            )
                          : Container(
                              // padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                // color: Colors.white,
                                borderRadius: BorderRadius.circular(55),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(imageUrl),
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(
                      height: 17,
                    ),
                    Text(
                      name.toUpperCase(),
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              top: 230,
              child: Material(
                elevation: 30,
                shadowColor: Colors.blueAccent,
                // borderRadius: BorderRadius.circular(20),
                shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Color(0xFFB176CC)),
                    borderRadius: BorderRadius.circular(25)),
                child: Container(
                    height: size.height * 0.63,
                    width: size.width * 0.9,
                    child: ListView.builder(
                        itemCount: details.length,
                        itemBuilder: (ctx, i) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20),
                            child: Container(
                              padding: const EdgeInsets.only(left: 10.0),
                              alignment: AlignmentDirectional.centerStart,
                              height: 50,
                              width: size.width * 0.7,
                              decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Text(
                                details[i],
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 19,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          );
                        })),
              ),
            ),
            Positioned(
              bottom: 8,
              child: InkWell(
                onTap: () async {
                  final result = await FilePicker.platform.pickFiles(
                    allowMultiple: false,
                    type: FileType.any,
                  );
                  if (result != null) {
                    filePath = result.files.single.path!;
                    fileName = result.files.single.name;
                    uploadImage();
                  } else {
                    print('file not selected');
                  }
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 7, horizontal: 20),
                  alignment: Alignment.center,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D5DD7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Change Profile Pic',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
