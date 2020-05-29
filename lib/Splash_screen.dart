import 'dart:async';

import 'package:flutter/material.dart';

//import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Main_Screen.dart';
import 'login_signup/Login_Screen.dart';
import 'package:flutter/services.dart';

class Splash_Screen extends StatefulWidget {
  @override
  _Splash_ScreenState createState() => _Splash_ScreenState();
}

class _Splash_ScreenState extends State<Splash_Screen> {
   starttime(bool home_screen) async {
    var _duration = Duration(seconds: 5);
    if (home_screen) {
      // user found
      return Timer(_duration, home_page);
    } else {
      // user not found
      return Timer(_duration, splash_screen);
    }
  }

  String auth;

  void splash_screen() {
    // navigate to login screen
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
         builder: (context) => Login_Screen(),
      ),
    );
  }

  void initplatrformstate() async {
// navigate to mainScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Main_Screen(),
      ),
    );
  }

  void home_page() {
    initplatrformstate();
  }
// getting user auth form database
  void getauth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      auth = prefs.getString("efuelworker_auth");
    });
    // check if user found or not and start time
    if (auth == null) {
      starttime(false);
    } else {
      starttime(true);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getauth();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/background.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              "assets/icon.png",
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.height / 5,
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                "SMART FUEL PORTFOILO",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
//            decoration: BoxDecoration(
//          image: buildBackgroundImage(),
    ));
  }
}
