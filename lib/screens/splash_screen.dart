import 'package:alpha/screens/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 3)).then((value) {
      Navigator.push(context, CupertinoPageRoute(builder: (_) => Login()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/united.jpeg',
              height: 200,
              width: 200,
            ),
            SizedBox(height: 20),
            SizedBox(width: 150, child: LinearProgressIndicator())
          ],
        ),
      ),
    );
  }
}
