import 'dart:convert';
import 'dart:io';

 import 'package:efuel_worker/loader.dart';
import 'package:efuel_worker/login_signup/resend_activiation_code.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../api_functions.dart';
 import 'package:http/http.dart'as http;
class forgetPassword extends StatefulWidget {
  @override
  _forgetPasswordState createState() => _forgetPasswordState();
}

class _forgetPasswordState extends State<forgetPassword> {
  final TextEditingController namecontroller = TextEditingController();

   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  Future<String> forget_password_function() async {

    String phonenumber;
//checking number match with default format
    if( namecontroller.text.split("")[0]=="9"&&namecontroller.text.split("").length==12){
      setState(() {
        phonenumber=namecontroller.text;
      });
    }
    else if(namecontroller.text.split("")[0]=="0"&&namecontroller.text.split("").length==14) {
      setState(() {
        phonenumber=namecontroller.text.substring(2,14);
      });
    }
    else if(namecontroller.text.split("")[0]=="0"&&namecontroller.text.split("").length==14) {
      setState(() {
        phonenumber=namecontroller.text.substring(2,14);
      });
    }
    else if(namecontroller.text.split("")[0]=="0"&&namecontroller.text.split("").length==15) {
      setState(() {
        phonenumber="966${namecontroller.text.substring(6,14)}";
      });
    }
    else if(namecontroller.text.split("")[0]=="5"&&namecontroller.text.split("").length==9) {
      setState(() {
        phonenumber="966${namecontroller.text}";
      });
    }
    else if(namecontroller.text.split("")[0]=="0"&&namecontroller.text.split("").length==10) {
      setState(() {
        phonenumber="966${namecontroller.text.substring(1,10)}";
      });
    }
    else {
      setState(() {
        phonenumber=namecontroller.text;
      });
    }
    // sending data to server to resnd password
    final response =
    await http.post("https://app.efuel-app.com/public/api/forgot_password", body: {

      api_functions().isNumeric(phonenumber)?"mobile":"email": phonenumber
    });
      print(json.decode(response.body));
    if(json.decode(response.body).toString().contains("error")){
      Loader.hideDialog(context);

// error data entered
      Flushbar(
        backgroundColor: Colors.red,

        title:  "something wrong",

        message:  json.decode(response.body)['error'].toString(),

        duration:  Duration(milliseconds: 1500),

      )..show(context);
    }
    else {
      Loader.hideDialog(context);

      Flushbar(
        backgroundColor: Colors.green,

        title:  "success",

        message:  "Password reset link has been sent ",

        duration:  Duration(milliseconds: 1500),

      )..show(context);

      // code sent to email and navigate to code activation screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Resend_Activiation_code(phonenumber),
        ),
      );



    }


    return "done";
  }
// name of phone widget
  Widget _name_phone_field() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10,top: 50),
      child: Theme(
        data: new ThemeData(
            primaryColor: Colors.blue,
            accentColor: Colors.blue,
            hintColor: Colors.grey),
        child: TextFormField(
          decoration: InputDecoration(
              hintText: "Your Email/Mobile/Code", filled: true, fillColor: Colors.white),
          keyboardType: TextInputType.emailAddress,
          autofocus: true,
          controller: namecontroller,
          validator: (String value) {
            if (value.isEmpty


                ) {
              return 'Please Enter a Valid E-mail or phone';
            }
          },

        ),
      ),
    );
  }


// confirm button
  Widget confirm_button() {
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
            if (!_formKey.currentState.validate()) {
              return;
            } else {


              Loader.showUnDismissibleLoader(context);
              forget_password_function();


            }

          },
          child: Text(
            "Enter Email or Phone",
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
        title: Text("Forget Password"),
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

                        _name_phone_field(),
                        SizedBox(
                          height: 15,
                        ),

                        confirm_button(),
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
