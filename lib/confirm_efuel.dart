import 'dart:convert';
import 'dart:io';

import 'package:efuel_worker/api_functions.dart';
import 'package:efuel_worker/loader.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
 import 'package:majascan/majascan.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class confirm_efuel extends StatefulWidget {
  confirm_efuel();

  @override
  _confirm_efuelState createState() => _confirm_efuelState();
}

class _confirm_efuelState extends State<confirm_efuel> {
  final TextEditingController qrCodeController = TextEditingController();
  String auth;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  // getting user auth from database

  void getauth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      auth = prefs.getString("efuelworker_auth");
    });
  }
  @override
  void initState() {
    super.initState();
    getauth();
  }
// codeField

  Widget Code_field() {
    return Padding(
      padding:
          const EdgeInsets.only(left: 15.0, right: 15, bottom: 10, top: 10),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: TextFormField(
          textAlign: TextAlign.center,
          controller: qrCodeController,
          maxLines: 2,
          decoration: InputDecoration(
              hintText: "Code",
              filled: true,
              fillColor: Colors.white,

              contentPadding: EdgeInsets.only(left: 15.0, top: 25),
              border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[400]),
                  borderRadius: BorderRadius.all(Radius.circular(5.0)))),
        ),
      ),
    );
  }


  // scan qrCode on customer phone to confirm fill
  Future _scan() async {

    String qrResult = await MajaScan.startScan(

        title: "Scan QR Station",

        barColor: Color(0xff003680),

        titleColor: Colors.white,

        qRCornerColor: Color(0xff003680),

        qRScannerColor: Color(0xff003680),

        flashlightEnable: true,
    );
     setState(() {
       if(qrResult.isNotEmpty){
       // Loader.showUnDismissibleLoader(context);

        api_functions().approve_transaction(auth, qrResult, context).then((response){
       //   Loader.hideDialog(context);
          if(response=="success"){

            // show alertDialog with success Message and get money from customer wallet
         //   Loader.hideDialog(context);
            _scaffoldKey.currentState.showSnackBar(
              SnackBar(
                backgroundColor:Colors.green,
                content: Text(
                  'Success',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          else {
          //  Loader.hideDialog(context);
// faild to fill
            _scaffoldKey.currentState.showSnackBar(
              SnackBar(
                backgroundColor:Colors.red,
                content: Text(
                  'Faild',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

        });
      }
      else {

      }
     });
  }
  // scan button
  Widget scan_button() {
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
// sending qrCode to server to confirm process
              api_functions().approve_transaction(auth, qrCodeController.text, context).then((response){
                if(response=="success"){
                  _scaffoldKey.currentState.showSnackBar(
                    SnackBar(
                      backgroundColor:Colors.green,
                      content: Text(
                        'success',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
                else {
                  _scaffoldKey.currentState.showSnackBar(
                    SnackBar(
                      backgroundColor:Colors.red,
                      content: Text(
                        'faild',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

              });

            }
          },
          child: Text(
            "APPROVE",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }

  Widget scannow() {
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

              _scan();


          },
          child: Text(
            "SCAN NOW",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
key: _scaffoldKey,
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
                        Code_field(),
                        SizedBox(
                          height: 15,
                        ),
                        scan_button(),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Text("-------------"),
                            Text("OR"),
                            Text("-------------"),
                          ],
                        ),
                        scannow(),
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
