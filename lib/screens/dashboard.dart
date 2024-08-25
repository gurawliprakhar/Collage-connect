import 'package:alpha/change_password.dart';
import 'package:alpha/screens/e_resource.dart';
import 'package:alpha/screens/gallery.dart';
import 'package:alpha/screens/login.dart';
import 'package:alpha/screens/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'chat.dart';
import 'chat_screen.dart';
import 'package:alpha/screens/event.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({
    Key? key,
  }) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late String option;

  String studentId = '';
  String name = '';
  // String rollNo = '';
  // String email = '';
  // String contact = '';
  String branch = '';
  String course = '';
  String imageUrl = '';
  // String year = '';
  // String dob = '';
  // String gender = '';
  // List<String> details = [];
  bool fetch = false;

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  var loggedInUser;

  @override
  void initState() {
    super.initState();
    // getCurrentUser();
    getCurrentUserDetail();
    // studentId = widget.id!;
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
                  // email = s['Email'];
                  // rollNo = s['University Roll No'];
                  // contact = s['Contact'];
                  course = s['Course'];
                  branch = s['Branch'];
                  imageUrl = s['ImageUrl'].toString();
                  // year = s['Year'];
                  // gender = s['Gender'];
                  // dob = s['DOB'];
                  fetch = true;
                  // print(imageUrl);
                });
              }
            }));
  }

  Future<void> launchURL(String url) async {
    final Uri uri = Uri(scheme: 'https', host: url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw "can not launch url";
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      drawer: SafeArea(
        child: Drawer(
          backgroundColor: const Color(0xFFCDE1FF),
          elevation: 10,
          child: ListView(
            children: [
              DrawerHeader(
                padding: EdgeInsets.zero,
                margin: EdgeInsets.zero,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/bk3.jpg'), fit: BoxFit.cover),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: CircleAvatar(
                        radius: 43,
                        child: imageUrl == 'null' || fetch == false
                            ? Image.asset(
                                "assets/profile.png",
                                fit: BoxFit.cover,
                              )
                            : Container(
                                // padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  // color: Colors.white,
                                  borderRadius: BorderRadius.circular(45),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(imageUrl),
                                  ),
                                ),
                              ),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          '$course $branch',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                        )
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ListTile(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        CupertinoPageRoute(builder: (_) => ChangePassword()));
                  },
                  title: const Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      'Change Password',
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  trailing: const Icon(
                    Icons.change_circle_outlined,
                    color: Colors.black,
                  )),
              ListTile(
                  onTap: () {
                    launchURL('www.united.ac.in');
                    Navigator.pop(context);
                  },
                  title: const Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      'Go to Website',
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  trailing: const Icon(
                    Icons.web,
                    color: Colors.black,
                  )),
              ListTile(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  title: const Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      'About Us',
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  trailing: const Icon(
                    Icons.summarize_outlined,
                    color: Colors.black,
                  )),
              ListTile(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return Container(
                            child: AlertDialog(
                              backgroundColor: Colors.black,
                              title: const Text(
                                'Logout?',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    _auth.signOut();
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        CupertinoPageRoute(
                                            builder: (_) => const Login()),
                                        (route) => false);
                                  },
                                  child: const Text(
                                    'Yes',
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          );
                        });
                  },
                  title: const Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      'Logout',
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  trailing: const Icon(
                    Icons.logout_outlined,
                    color: Colors.black,
                  ))
            ],
          ),
        ),
      ),
      body: Container(
        height: size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/bk2.jpg'), fit: BoxFit.cover),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 25.0, horizontal: 30),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                color: Colors.white60,
                child: SizedBox(
                  height: 130,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: CircleAvatar(
                          radius: 43,
                          child: imageUrl == 'null' || fetch == false
                              ? Image.asset(
                                  "assets/profile.png",
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  // padding: const EdgeInsets.all(30),
                                  decoration: BoxDecoration(
                                    // color: Colors.white,
                                    borderRadius: BorderRadius.circular(45),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(imageUrl),
                                    ),
                                  ),
                                ),
                        ),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Text(
                              name,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            '$course $branch',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          )
                        ],
                      ),
                      // const SizedBox(
                      //   width: 10,
                      // ),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context, CupertinoPageRoute(builder: (_) => Profile()));
                  },
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(10),
                    height: 150,
                    width: 150,
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/profile.png',
                          height: 100,
                          width: 100,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Text('PROFILE')
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context, CupertinoPageRoute(builder: (_) => Event()));
                  },
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(10),
                    height: 150,
                    width: 150,
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/Event.png',
                          height: 100,
                          width: 100,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Text('EVENT')
                      ],
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context, CupertinoPageRoute(builder: (_) => Chat()));
                  },
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(10),
                    height: 150,
                    width: 150,
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/chat.png',
                          height: 100,
                          width: 100,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Text('CHATBOX')
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        CupertinoPageRoute(builder: (_) => ChatScreen()));
                  },
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(10),
                    height: 150,
                    width: 150,
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/Discuss3.png',
                          height: 100,
                          width: 100,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Text('DISCUSS')
                      ],
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.push(context,
                        CupertinoPageRoute(builder: (_) => EResource()));
                  },
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(10),
                    height: 150,
                    width: 150,
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/E-resource.png',
                          height: 100,
                          width: 100,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Text('E-RESOURCE')
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context, CupertinoPageRoute(builder: (_) => Gallery()));
                  },
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(10),
                    height: 150,
                    width: 150,
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/Gallery.png',
                          height: 100,
                          width: 100,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        const Text('GALLERY')
                      ],
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
