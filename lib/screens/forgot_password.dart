import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final auth = FirebaseAuth.instance;

  TextEditingController email = TextEditingController();
  Constants c = Constants();

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
      resizeToAvoidBottomInset: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('ForgotPassword'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
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
                // decoration: BoxDecoration(
                //   borderRadius: BorderRadius.circular(20),
                //   image: const DecorationImage(
                //       image: AssetImage('assets/united.jpeg'),
                //       fit: BoxFit.fill),
                // ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10.0, bottom: 50),
              child: Center(
                child: Text(
                  'Enter your email address to reset password',
                  style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.normal),
                ),
              ),
            ),
            c.createTextField(
              title: 'Email',
              keyboardType: TextInputType.emailAddress,
              controller: email,
            ),
            Container(
              height: 52,
              margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.greenAccent.shade700,
              ),
              child: TextButton(
                onPressed: () {
                  auth
                      .sendPasswordResetEmail(email: email.text.toString())
                      .then((value) {
                    Navigator.pop(context);
                    showInSnackBar(
                        value:
                            'We have sent you password reset link on your email',
                        context: context);
                  }).onError((error, stackTrace) {
                    showInSnackBar(value: error.toString(), context: context);
                  });
                },
                child: const Text(
                  'Next',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
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
