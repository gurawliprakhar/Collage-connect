import 'package:alpha/constants.dart';
import 'package:alpha/screens/sign_up.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Otp extends StatefulWidget {
  const Otp({Key? key}) : super(key: key);

  static String verify = '';

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {
  final _auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  late String id;
  late String pass;
  late String phoneNo;
  late String otpMsg;

  TextEditingController studentId = TextEditingController();
  TextEditingController otp = TextEditingController();

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

  Future<bool> isExist(String id) async {
    final messages = await firestore.collection('user').get();
    for (var sId in messages.docs) {
      if (sId.id.toString() == id) {
        return true;
      }
    }
    return false;
  }

  Future<String> getMobileNo(String id) async {
    String phoneNo = "";
    final messages = await firestore.collection('user').get();
    for (var sId in messages.docs) {
      if (sId.id.toString() == id) {
        phoneNo = sId['Contact'].toString();
      }
    }
    return phoneNo;
  }

  void sendOTP(String phoneNo) async {
    String phone = '+91$phoneNo';
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phone.toString(),
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          print(e.message);
        },
        codeSent: (String verificationId, int? resendToken) {
          Otp.verify = verificationId;
          //[Show user message here that OTP sent]
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } on Exception catch (e) {
      print(e.toString());
      // Handle exception here
    }
  }

  void verifyOTP(String otp) async {
    var credentials =
        PhoneAuthProvider.credential(verificationId: Otp.verify, smsCode: otp);

    try {
      await _auth.signInWithCredential(credentials);
      showInSnackBar(value: 'Verification Successful', context: context);
      Navigator.push(
          context, CupertinoPageRoute(builder: (_) => SignUp(id: id)));
    } catch (e) {
      showInSnackBar(value: 'Invalid OTP', context: context);
    }
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
              padding: EdgeInsets.only(top: 10.0, bottom: 50),
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
                title: 'Student Id',
                keyboardType: TextInputType.number,
                controller: studentId,
                enabled: enabled),
            Container(
              height: 52,
              margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.greenAccent.shade700,
              ),
              child: TextButton(
                onPressed: () async {
                  if (studentId.text.trim().isEmpty) {
                    showInSnackBar(
                        value: 'Please enter Student Id', context: context);
                  } else {
                    id = studentId.text;
                    if (await isExist(id)) {
                      phoneNo = await getMobileNo(id);
                      sendOTP(phoneNo);
                      setState(() {
                        enabled = false;
                      });
                    } else {
                      showInSnackBar(
                          value: 'Please enter valid Student Id',
                          context: context);
                    }
                  }
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
            ),
            const SizedBox(
              height: 20,
            ),
            !enabled
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                            horizontal: 55.0, vertical: 10)
                        .copyWith(bottom: 0),
                    child: const Text(
                      'Enter the OTP: ',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w600),
                    ),
                  )
                : const SizedBox(),
            !enabled
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50.0, vertical: 10),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      child: TextField(
                        controller: otp,
                        style: const TextStyle(fontSize: 18),
                        cursorColor: Colors.black,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.phone,
                        maxLength: 6,
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(6),
                        ],
                        decoration: InputDecoration(
                          counterText: '',
                          border: const OutlineInputBorder(
                              borderSide: BorderSide.none),
                          hintText: 'OTP',
                          hintStyle: TextStyle(
                              color: Colors.black.withOpacity(0.5),
                              fontSize: 18),
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
            !enabled
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 100.0, vertical: 20),
                    child: InkWell(
                      onTap: () async {
                        otpMsg = otp.text;
                        if (otpMsg.trim().isEmpty) {
                          showInSnackBar(
                              value: 'Please enter OTP', context: context);
                        } else {
                          verifyOTP(otpMsg);
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
                        child: const Text(
                          'Submit',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
