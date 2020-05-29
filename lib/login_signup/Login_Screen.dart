import 'dart:io';

import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;
import 'dart:convert' show json;
import 'package:shared_preferences/shared_preferences.dart';

import '../Main_Screen.dart';
import '../loader.dart';
import 'forget_password.dart';

String user_role;

class Login_Screen extends StatefulWidget {
  @override
  _Login_ScreenState createState() => _Login_ScreenState();
}

class _Login_ScreenState extends State<Login_Screen> {
  TextEditingController email_controller = TextEditingController();
  TextEditingController password_controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
   String auth;



 // email widget
  Widget email_field() {
    return Padding(
      padding:
          const EdgeInsets.only(left: 15.0, right: 15, bottom: 10, top: 10),
      child: Container(
        height: MediaQuery.of(context).size.height / 18,
        child: TextFormField(
          textAlign: TextAlign.left,
          controller: email_controller,
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 15.0, top: 10),
              hintText: "Email Account or Phone",
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.green[400]),
                  borderRadius: BorderRadius.all(Radius.circular(10.0)))),
          keyboardType: TextInputType.emailAddress,
        ),
      ),
    );
  }
// password widget
  Widget password_field() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15),
      child: Container(
        height: MediaQuery.of(context).size.height / 18,
        child: TextFormField(
          textAlign: TextAlign.left,
          obscureText: true,
          controller: password_controller,
          decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(left: 15.0, top: 10),
              hintText: "Password",
              filled: true,
              fillColor: Colors.white,

//            enabledBorder: OutlineInputBorder(
//              borderRadius: BorderRadius.circular(25),
//
//              borderSide: BorderSide(color: Colors.green[400]),
//            ),
//

              border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)))),
          keyboardType: TextInputType.emailAddress,
        ),
      ),
    );
  }
// forget password widget
  Widget forget_password() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => forgetPassword(),
            ),
          );
        },
        child: Text(
          "Forget password",
          style: TextStyle(
              decoration: TextDecoration.underline,
              color: Colors.grey[400],
              fontSize: 12),
        ),
      ),
    );
  }
// login button
  Widget Login_button() {
    return Container(
      width: MediaQuery.of(context).size.width / 1.1,
      height: MediaQuery.of(context).size.height / 20,
      child: RaisedButton(
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(10.0),
        ),
        color: Color(0xff003680),
        onPressed: () {
          if (email_controller.text.isEmpty ||
              password_controller.text.isEmpty) {
            Flushbar(
              backgroundColor: Colors.red,
              title: "error",
              message: "please enter e-mail and password  !!",
              duration: Duration(milliseconds: 1500),
            )..show(context);
          } else {
            Loader.showUnDismissibleLoader(context);
            login_function();
          }
        },
        child: Text(
          "LOGIN",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  Future<String> login_function() async {
      String phonenumber;
// check matching phone with default of country
    if (email_controller.text.split("")[0] == "9" &&
        email_controller.text.split("").length == 12) {

      setState(() {
        phonenumber = email_controller.text;
      });
     } else if (email_controller.text.split("")[0] == "9" &&
        email_controller.text.split("").length == 13) {
        setState(() {
        phonenumber = "966${email_controller.text.substring(4, 13)}";
      });
     } else if (email_controller.text.split("")[0] == "0" &&
        email_controller.text.split("").length == 14) {
        setState(() {
        phonenumber = email_controller.text.substring(2, 14);
      });
     } else if (email_controller.text.split("")[0] == "0" &&
        email_controller.text.split("").length == 15) {
        setState(() {
        phonenumber = "966${email_controller.text.substring(6, 14)}";
      });
     } else if (email_controller.text.split("")[0] == "5" &&
        email_controller.text.split("").length == 9) {
        setState(() {
        phonenumber = "966${email_controller.text}";
      });
     } else if (email_controller.text.split("")[0] == "0" &&
        email_controller.text.split("").length == 10) {
        setState(() {
        phonenumber = "966${email_controller.text.substring(1, 10)}";
      });
     } else {
      setState(() {
        phonenumber = email_controller.text;
      });
    }
// sending login request with data to server
     final response =
        await http.post("https://app.efuel-app.com/public/oauth/token", body: {
      "grant_type": "password",
      "client_id": "2",
      "client_secret": "uLFGKUMOyJwkUXFo9snUynbPs8C2Ls0OQNFVlOXj",
      "username": phonenumber,
      "password": password_controller.text
    });


    if (json.decode(response.body)['access_token'] != null) {
      setState(() {
        auth = "Bearer ${json.decode(response.body)['access_token']}";
      });
      // success login
      get_profile();
    } else {
      Loader.hideDialog(context);
// error email or password
      Flushbar(
        backgroundColor: Colors.red,
        title: "something wrong",
        message: "e-mail or password is wrong !!",
        duration: Duration(milliseconds: 1500),
      )..show(context);
    }
    return "done";
  }

  void get_profile() async {
    final String url = 'https://app.efuel-app.com/public/api/user_role';
    var response = await http.post(
      Uri.encodeFull(url),
      headers: {
        "Accept": "Application/json",
        HttpHeaders.authorizationHeader: auth
      },
    );
    Loader.hideDialog(context);
// chcking user rule if worker of client
    user_role = '${json.decode(response.body)['role']}';

    if (user_role == 'worker') {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("efuelworker_auth", "$auth");
       Loader.hideDialog(context);
// vaild worker data and navigate to home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Main_Screen(),
        ),
      );
    } else {
      // invaild worker rule

      Flushbar(
        backgroundColor: Colors.red,
        title: "something wrong",
        message: "e-mail or password is wrong !!",
        duration: Duration(milliseconds: 1500),
      )..show(context);
    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/background.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Image.asset(
                            "assets/icon.png",
                            width: MediaQuery.of(context).size.width / 2,
                            height: MediaQuery.of(context).size.height / 5,
                          ),
                        ),
                        Center(
                          child: Text(
                            "SMART FUEL PORTFOILO",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        email_field(),
                        password_field(),
                        forget_password(),
                        Login_button(),
                      ],
                    ),
                  ) /* add child content here */
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
