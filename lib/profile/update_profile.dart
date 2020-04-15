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

class Update_profile extends StatefulWidget {
  @override
  _Update_profileState createState() => _Update_profileState();
}

class _Update_profileState extends State<Update_profile> {
  TextEditingController username_controller = TextEditingController();
  TextEditingController mobile_controller = TextEditingController();
  TextEditingController email_controller = TextEditingController();
  String auth;

  @override
  void initState() {
    super.initState();
    getauth();
  }
  // getting user data from server
  void get_profile() async {

    final String url = 'https://app.efuel-app.com/public/api/get_profile';
    var response = await http.post(
      Uri.encodeFull(url),
      headers: {
        "Accept": "Application/json",
        HttpHeaders.authorizationHeader:auth
      },
    );
setState(() {
  username_controller.text=json.decode(response.body)['name'];
  mobile_controller.text=json.decode(response.body)['mobile'];
  email_controller.text=json.decode(response.body)['email'];
});



  }

  // getting user auth from server

  void getauth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      auth = prefs.getString("efuelworker_auth");
    });
    get_profile();
  }
// sending new data to server to update it
  Future<String> update_profile() async {

      final response = await http.post(
          "https://app.efuel-app.com/public/api/update_profile",
          headers: {
            "Accept": "Application/json",
            HttpHeaders.authorizationHeader: '$auth'
          },
          body: {
            "name": username_controller.text,
            "mobile": mobile_controller.text,
            "email": email_controller.text
          }).then((dd) async {
        print("fwefefef${json.decode(dd.body)}");

        Loader.hideDialog(context);

        Navigator.of(context).pop();
      });

  }
// userName widget
  Widget user_name_widget() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15),
      child: Container(
        height: MediaQuery.of(context).size.height / 10,
        child: TextFormField(
          controller: username_controller,
          decoration: InputDecoration(
              labelText: 'User name',
              fillColor: Colors.white,
            ),

        ),
      ),
    );
  }


  // mobile widget
  Widget mobile_widget() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15),
      child: Container(
        height: MediaQuery.of(context).size.height / 10,
        child: TextFormField(
          controller: mobile_controller,
          decoration: InputDecoration(
              labelText: 'Mobile',
              fillColor: Colors.white,
             ),

        ),
      ),
    );
  }


  // email widget
  Widget email_widget() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15),
      child: Container(
        height: MediaQuery.of(context).size.height / 10,
        child: TextFormField(
          controller: email_controller,
          decoration: InputDecoration(
              labelText: 'Email Account',
              fillColor: Colors.white,
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
        title: Text("Edit Profile"),
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

              user_name_widget(),
              SizedBox(
                height: 20,
              ),

              mobile_widget(),
              SizedBox(
                height: 20,
              ),
              email_widget(),
              SizedBox(
                height: 20,
              ),


              // update button widget
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
