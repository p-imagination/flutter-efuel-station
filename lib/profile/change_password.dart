import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:efuel_worker/loader.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
 import 'package:http/http.dart' as http;

class change_password extends StatefulWidget {
  @override
  _change_passwordState createState() => _change_passwordState();
}

class _change_passwordState extends State<change_password> {
  TextEditingController oldpass_controoler = TextEditingController();
  TextEditingController newpass_controoler = TextEditingController();
  TextEditingController repeatpass_controoler = TextEditingController();
  String auth;

  @override
  void initState() {
    super.initState();
    getauth();
  }
// getting user auth from database
  void getauth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      auth = prefs.getString("efuelworker_auth");
    });
  }
// sending new data to server to store it
  Future<String> update_profile() async {
    // check two password is identical
    if (newpass_controoler.text == repeatpass_controoler) {
      final response = await http.post(
          "https://app.efuel-app.com/public/api/change_password",
          headers: {
            "Accept": "Application/json",
            HttpHeaders.authorizationHeader: '$auth'
          },
          body: {
            "current_password": oldpass_controoler.text,
            "password": newpass_controoler.text,
            "password_confirmation": repeatpass_controoler.text
          }).then((dd) async {

        Loader.hideDialog(context);

        Navigator.of(context).pop();
      });
    } else {

      Loader.hideDialog(context);
      Flushbar(
        title: "خطأ ",
        message: "كلمتي المرور غير متطابقتين",
        duration: Duration(milliseconds: 1500),
      )..show(context);
    }
  }

  Widget old_password() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15),
      child: Container(
        height: MediaQuery.of(context).size.height / 12,
        child: TextFormField(
          controller: oldpass_controoler,
          decoration: InputDecoration(
              labelText: 'Current Password',
              fillColor: Colors.white,
            ),
          obscureText: true,
          validator: (String value) {
            if (value.isEmpty) {
              return 'Current Password';
            }
          },
        ),
      ),
    );
  }

  Widget new_password() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15),
      child: Container(
        height: MediaQuery.of(context).size.height / 12,
        child: TextFormField(
          controller: newpass_controoler,
          decoration: InputDecoration(
              labelText: 'New Password',
              fillColor: Colors.white,
             ),
          obscureText: true,
          validator: (String value) {
            if (value.isEmpty) {
              return 'New Password';
            }
          },
        ),
      ),
    );
  }

  Widget repeat_newpawword() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15),
      child: Container(
        height: MediaQuery.of(context).size.height / 12,
        child: TextFormField(
          controller: repeatpass_controoler,
          decoration: InputDecoration(
              labelText: 'Confirm Password',
              fillColor: Colors.white,
           ),
          obscureText: true,
          validator: (String value) {
            if (value.isEmpty) {
              return 'Confirm Password';
            }
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff003680),
        title: Text("Change Password"),
       centerTitle: true,
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15),
                child: Text("Current Password"),
              ),
              old_password(),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15),
                child: Text("New Password"),
              ),
              new_password(),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15),
                child: Text("Confirm Password"),
              ),
              repeat_newpawword(),
              SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.center,
                height: MediaQuery.of(context).size.height / 14,
                width: MediaQuery.of(context).size.width / 1.1,
                child: new RaisedButton(
                  color: Colors.blue,
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(25.0)),
                  child: Text(
                    'Update',
                    style: TextStyle(
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                        color: Colors.white),
                  ),
                  onPressed: () {
                    Loader.showUnDismissibleLoader(context);
                    update_profile();

                    //                        _formKey.currentState.save();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
