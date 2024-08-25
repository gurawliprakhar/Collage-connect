import 'package:alpha/constants.dart';
import 'package:alpha/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({Key? key}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  Constants c = Constants();
  TextEditingController currPass = TextEditingController();
  TextEditingController newPass = TextEditingController();
  TextEditingController cfmPass = TextEditingController();

  var auth = FirebaseAuth.instance;
  var currentUser = FirebaseAuth.instance.currentUser;

  changePassword({email, oldPassword, newPassword}) async {
    var cred =
        EmailAuthProvider.credential(email: email, password: oldPassword);
    await currentUser?.reauthenticateWithCredential(cred).then((value) {
      currentUser?.updatePassword(newPassword);

      auth.signOut();
      Navigator.pushAndRemoveUntil(context,
          CupertinoPageRoute(builder: (_) => const Login()), (route) => false);
      showInSnackBar(
          value: "Password changed successfully!!\nLogin again",
          context: context);
    }).catchError((error) {
      showInSnackBar(value: error.toString(), context: context);
    });
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Change Password'),
      ),
      body: ListView(
        // shrinkWrap: true,
        children: [
          const SizedBox(
            height: 50,
          ),
          textField(title: 'Current Password', controller: currPass),
          textField(title: 'New Password', controller: newPass),
          textField(title: 'Confirm Password', controller: cfmPass),
          const SizedBox(
            height: 80,
          ),
          Center(
            child: InkWell(
              onTap: () async {
                if (currPass.text.trim().isEmpty) {
                  showInSnackBar(
                      value: 'Please input username', context: context);
                } else if (newPass.text.trim().isEmpty) {
                  showInSnackBar(
                      value: 'Please enter the new password', context: context);
                } else if (cfmPass.text.trim().isEmpty) {
                  showInSnackBar(
                      value: 'Please re-enter the new password',
                      context: context);
                } else if (newPass.text.trim() != cfmPass.text.trim()) {
                  showInSnackBar(
                      value: 'Password mismatched', context: context);
                } else {
                  await changePassword(
                    email: currentUser?.email,
                    oldPassword: currPass.text,
                    newPassword: newPass.text,
                  );
                }
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                alignment: Alignment.center,
                height: 50,
                width: 300,
                decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [Color(0xFF3739A6), Color(0xFF8B4FE3)]),
                    borderRadius: BorderRadius.circular(20)),
                child: const Text(
                  'Update Password',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget textField(
    {required String title, required TextEditingController controller}) {
  bool hide = true;
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      // decoration: BoxDecoration(
      //     color: Colors.white.withOpacity(0.5),
      //     borderRadius: BorderRadius.circular(20)),
      child: StatefulBuilder(builder: (ctx, setState) {
        return TextField(
          controller: controller,
          keyboardType: TextInputType.text,
          obscureText: hide,
          style: const TextStyle(fontSize: 18),
          decoration: InputDecoration(
            // border: OutlineInputBorder(borderSide: BorderSide()),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.cyan, width: 2),
            ),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.black, width: 2),
            ),
            labelText: title,
            labelStyle: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
            suffixIcon: IconButton(
                iconSize: 22,
                onPressed: () {
                  setState(() {
                    hide = !hide;
                  });
                },
                icon: Icon(hide
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined)),
            hintText: title,
            hintStyle: const TextStyle(fontSize: 18),
          ),
        );
      }),
    ),
  );
}
