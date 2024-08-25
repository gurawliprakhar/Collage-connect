import 'package:alpha/constants.dart';
import 'package:alpha/screens/dashboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key, this.id}) : super(key: key);

  final String? id;

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    studentId = widget.id!;
  }

  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  late String studentId;

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  Constants c = Constants();
  bool enabled = true;
  bool isLoading = false;

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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        height: size.height,
        // width: size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/bg_alpha.jpeg'), fit: BoxFit.cover),
        ),
        child: ListView(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 40, horizontal: 130),
              child: Container(
                height: 145,
                width: 145,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  // image: const DecorationImage(
                  //     image: AssetImage('assets/united.jpeg'),
                  //     fit: BoxFit.fill),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(28.0),
              child: Center(
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ),
            c.createTextField(
                title: 'Email',
                keyboardType: TextInputType.emailAddress,
                controller: username,
                enabled: enabled),
            c.createTextField(
                title: 'Create Password',
                keyboardType: TextInputType.text,
                controller: password,
                isPassword: true,
                enabled: enabled),
            c.createTextField(
                title: 'Confirm Password',
                keyboardType: TextInputType.text,
                controller: confirmPassword,
                isPassword: true,
                enabled: enabled),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),
              child: InkWell(
                onTap: enabled
                    ? () async {
                        setState(() {
                          enabled = false;
                          isLoading = true;
                          Future.delayed(const Duration(seconds: 1))
                              .then((value) {
                            setState(() {
                              isLoading = false;
                            });
                          });
                        });
                        if (username.text.trim().isEmpty) {
                          showInSnackBar(
                              value: 'Please input username', context: context);
                        } else if (password.text.trim().isEmpty) {
                          showInSnackBar(
                              value: 'Please input password', context: context);
                        } else if (confirmPassword.text.trim().isEmpty) {
                          showInSnackBar(
                              value: 'Please confirm your password',
                              context: context);
                        } else if (password.text.trim() !=
                            confirmPassword.text.trim()) {
                          showInSnackBar(
                              value: 'Password mismatched', context: context);
                        } else {
                          try {
                            await _auth.createUserWithEmailAndPassword(
                                email: username.text, password: password.text);

                            _firestore
                                .collection('user')
                                .doc(studentId)
                                .update({
                              'Email': username.text,
                            });

                            Navigator.pushAndRemoveUntil(
                                context,
                                CupertinoPageRoute(builder: (_) => Dashboard()),
                                (route) => false);
                          } catch (e) {
                            showInSnackBar(
                                value: e.toString(), context: context);
                          }
                        }
                      }
                    : null,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.greenAccent.shade700,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          'Submit',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w400),
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
