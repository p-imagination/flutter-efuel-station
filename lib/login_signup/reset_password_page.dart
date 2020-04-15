import 'dart:convert';
import 'dart:io';

 import 'package:efuel_worker/loader.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
  import 'package:shared_preferences/shared_preferences.dart';

import '../Main_Screen.dart';
import '../api_functions.dart';
 import 'package:http/http.dart'as http;
class reset_password_page extends StatefulWidget {
  String phone_number_or_email,codetext;


  reset_password_page(this.phone_number_or_email,this.codetext);

  @override
  _reset_password_pageState createState() => _reset_password_pageState();
}

class _reset_password_pageState extends State<reset_password_page> {
  final TextEditingController passwordcontroller = TextEditingController();
  String auth;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  Future<String> password_function(BuildContext ctx) async {

// sending new password to server to set it
     Loader.showUnDismissibleLoader(ctx);
    final response =
    await http.post("https://app.efuel-app.com/public/api/reset_password", body:


    api_functions().isNumeric(widget.phone_number_or_email)?
    {

      "email": "",
      "mobile": widget.phone_number_or_email,
      "reset_code": widget.codetext,
      "password": passwordcontroller.text
    }:{

      "email": "${widget.phone_number_or_email}",
      "mobile": "",
      "reset_code": widget.codetext,
      "password": passwordcontroller.text
    });


     print(json.decode(response.body));
    if((response.statusCode==200)){
// success setting new password and navigate to homescreen
      setState(() {
        auth = "Bearer ${json.decode(response.body)['token']}";
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("efuelworker_auth", "$auth");

      Loader.hideDialog(ctx);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
           builder: (context) => Main_Screen(),
        ),
      );


    }
    else {



 // error setting password

      Flushbar(
        backgroundColor: Colors.red,
        title: "Error",
        message: "${json.decode(response.body)['error']}",
        duration: Duration(milliseconds: 1500),
      )..show(context);    }


    return "done";
  }
// password widget
  Widget _password_field() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10,top: 50),
      child: Theme(
        data: new ThemeData(
            primaryColor: Colors.blue,
            accentColor: Colors.blue,
            hintColor: Colors.grey),
        child: TextFormField(
          decoration: InputDecoration(
              hintText: "Your Password", filled: true, fillColor: Colors.white),
          keyboardType: TextInputType.emailAddress,
          autofocus: true,
          controller: passwordcontroller,
          validator: (String value) {
            if (value.isEmpty


            ) {
              return 'Please Enter a password';
            }
          },

        ),
      ),
    );
  }


// confirm password button
  Widget password_button() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Container(
        width: MediaQuery.of(context).size.width / 1.5,
        height: MediaQuery.of(context).size.height / 17,
        child: RaisedButton(
          shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(10.0),
          ),
          color: Color(0xff0276cd),
          onPressed: () {
            // checking field not empty
            if (!_formKey.currentState.validate()) {
              return;
            } else {


               password_function(context);


            }

          },
          child: Text(
            "Login",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff003680),
        title: Text("Enter Password"),
      ),
      body: Form(
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
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[

                        _password_field(),
                        SizedBox(
                          height: 15,
                        ),

                        password_button(),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
