import 'dart:async';

import 'package:e_imavi/pages/base.dart';
import 'package:e_imavi/pages/home.dart';
import 'package:e_imavi/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreenPage extends StatefulWidget {
  SplashScreenPage({Key? key}) : super(key: key);

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  startSplash() async {
    var duration = new Duration(seconds: 1);
    Timer(
      duration,
      route,
    );
  }

  void route() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    var token = sp.getString('profileToken');

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 1000),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        pageBuilder: (context, animation, anotherAnimation) {
          return token == null ? LoginPage() : BaseLayout();
        },
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startSplash();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/images/logoImavi.png', scale: 2,),
            SizedBox(height: 20,),
            Text(
              "E-IMAVI",
              style: TextStyle(
                color: Color.fromARGB(255, 84, 0, 130),
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
