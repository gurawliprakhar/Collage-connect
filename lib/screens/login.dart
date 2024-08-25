import 'package:alpha/constants.dart';
import 'package:alpha/screens/dashboard.dart';
import 'package:alpha/screens/otp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'forgot_password.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _auth = FirebaseAuth.instance;

  bool hidePassword = true;
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  Constants c = Constants();
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
    return SafeArea(
        child: Scaffold(
      body: Container(
        alignment: Alignment.center,
        height: size.height,
        width: size.width,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/bg_alpha.jpeg'), fit: BoxFit.cover),
        ),
        child: ListView(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                  padding: EdgeInsets.all(15.0),
                  child: Center(
                    child: Text(
                      'Sign In',
                      style: TextStyle(
                          fontSize: 26,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                c.createTextField(
                    title: 'Username',
                    keyboardType: TextInputType.emailAddress,
                    controller: username),
                c.createTextField(
                    title: 'Password',
                    keyboardType: TextInputType.text,
                    controller: password,
                    isPassword: true),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (_) => const ForgotPassword(),
                        ),
                      );
                    },
                    child: const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Forgot Password',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 20),
                  child: InkWell(
                    onTap: () async {
                      if (username.text.trim().isEmpty) {
                        showInSnackBar(
                            value: 'Please input username', context: context);
                      } else if (password.text.trim().isEmpty) {
                        showInSnackBar(
                            value: 'PLease input password', context: context);
                      } else {
                        try {
                          final user = await _auth.signInWithEmailAndPassword(
                              email: username.text, password: password.text);

                          if (user != null) {
                            setState(() {
                              isLoading = true;
                            });

                            Future.delayed(const Duration(seconds: 1))
                                .then((value) {
                              setState(() {
                                isLoading = false;
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    CupertinoPageRoute(
                                        builder: (_) => const Dashboard()),
                                    (route) => false);
                              });
                            });
                          }
                        } catch (e) {
                          showInSnackBar(
                              value: 'Invalid Credentials', context: context);
                        }
                      }
                    },
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.greenAccent.shade700,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 3,
                              ),
                            )
                          : const Text(
                              'Login',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600),
                            ),
                    ),
                  ),
                ),
                isLoading
                    ? const SizedBox()
                    : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (_) => const Otp(),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.lightBlueAccent.shade700,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'SignUp',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w400),
                            ),
                          ),
                        ),
                      )
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
