import 'dart:convert';
import 'dart:io';

import 'package:efuel_worker/loader.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class api_functions {
  Future get_code(String phone, BuildContext context) async {
    final String url = 'https://app.efuel-app.com/public/api/get_mobile_code';
    var response = await http.post(Uri.encodeFull(url), headers: {
      "Accept": "Application/json",
    }, body: {
      'mobile': "966521107895"
    });
    Loader.hideDialog(context);
    if (response.statusCode == 200) {
    } else {}
  }

  Future approve_transaction(
      String auth, String uid, BuildContext context) async {
    final String url =
        'https://app.efuel-app.com/public/api/approve_transaction';
    var response = await http.post(Uri.encodeFull(url), headers: {
      "Accept": "Application/json",
      HttpHeaders.authorizationHeader: '${auth}'
    }, body: {
      "uid": uid,
    });
 //   Loader.hideDialog(context);

    if (response.statusCode == 200) {
      return "success";
    } else {
      return "failed";
    }
  }

  Future get_worker_transactions(String auth, BuildContext context) async {
    final String url =
        'https://app.efuel-app.com/public/api/get_worker_transactions';
    var response = await http.post(
      Uri.encodeFull(url),
      headers: {
        "Accept": "Application/json",
        HttpHeaders.authorizationHeader: '${auth}'
      },
    );
    if (response.statusCode == 200) {
      return json.decode(response.body)['transactions'];
    } else {}
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.parse(s, (e) => null) != null;
  }
}
