import 'dart:convert';
import 'dart:io';

  import 'package:efuel_worker/login_signup/reset_password_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Widgets_.dart';
 import 'forget_password.dart';
import 'package:http/http.dart'as http;

class Resend_Activiation_code extends StatefulWidget {
  String phone_number_or_email;


  Resend_Activiation_code(this.phone_number_or_email);

  @override
  _Resend_Activiation_codeState createState() => _Resend_Activiation_codeState();
}

class _Resend_Activiation_codeState extends State<Resend_Activiation_code> {
  final TextEditingController codecontroller = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

// verfiy code widget

  Widget _verfiycode_field() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Theme(
        data: new ThemeData(
            primaryColor: Colors.white,
            accentColor: Colors.white,
            hintColor: Colors.grey),
        child: TextFormField(
          textAlign: TextAlign.center,
          decoration: InputDecoration(
              hintText: "____  ____  ____  ____ ", filled: true, fillColor: Colors.white),
          keyboardType: TextInputType.number,
          autofocus: true,
          controller: codecontroller,
          validator: (String value) {
            if (value.isEmpty

                //|| !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")

                //        .hasMatch(value)

                ) {
              return 'Please Enter a Valid code';
            }
          },

        ),
      ),
    );
  }

// active code widget
  Widget active_button() {
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
               verfiy_function();

//              Navigator.push(
//                context,
//                MaterialPageRoute(
//                  builder: (context) => Email_phone(),
//                ),
//              );
            }

          },
          child: Text(
            "Active",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }




  void verfiy_function() async {
    // navigate to password page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => reset_password_page(widget.phone_number_or_email,codecontroller.text),
      ),
    );
  }

// sending resend code request to server
  void  resendcode_function() async {

    final String url = 'https://app.efuel-app.com/public/api/resend_mobile_code';
    var response = await http.post(Uri.encodeFull(url), headers: {
      "Accept": "Application/json",
    }, body: {
      "mobile": widget.phone_number_or_email,
     });
      if(response.statusCode==200){

// request Sent
    }
    else {
// error while Resending code
      Widgets_class().snackbar_widget("${json.decode(response.body)['message']}", _scaffoldKey);

    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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

                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text("Activation",style: TextStyle(fontSize: 20),),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text("${widget.phone_number_or_email}",style: TextStyle(fontSize: 20,color: Colors.black),),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20,left: 10,right: 10),
                          child: Text("Enter activiation code you got on your mobile :",style: TextStyle(fontSize: 16),),
                        ),
                         _verfiycode_field(),
                        SizedBox(
                          height: 15,
                        ),



                        active_button(),
                        SizedBox(
                          height: 10,
                        ),

                        FlatButton(child: Text("Resend",style: TextStyle(fontSize: 20),),onPressed: (){
                           resendcode_function();
                        },)
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
