import 'package:flutter/material.dart';


class Widgets_class{

  // show alert message
  Widget snackbar_widget(String value, GlobalKey<ScaffoldState> _scaffoldKey) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(value),
      backgroundColor: Colors.red,
      duration: Duration(seconds: 1),
    ));
  }
}