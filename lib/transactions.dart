import 'package:efuel_worker/loader.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'api_functions.dart';

class Transactions extends StatefulWidget {
  @override
  _TransactionsState createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  String auth;

  List workertransactions;
// getting user auth from database
  void getauth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      auth = prefs.getString("efuelworker_auth");
    });
// getting all worker transactions from server
    api_functions().get_worker_transactions(auth, context).then((response) {
      setState(() {
        workertransactions = response;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getauth();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
            color: Colors.grey[100],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: workertransactions == null
                  ? Container(         width: MediaQuery.of(context).size.width/7,
                height: MediaQuery.of(context).size.height/7, child: Center(
                  child: CircularProgressIndicator(
                  backgroundColor: Colors.blue,
              ),
                ),)
                  : workertransactions.length == 0
                      ? Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                          child: Center(child: Text("no transactions found")),
                        )
                      : Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height ,
                          color: Colors.white,
                          child: ListView.builder(
                              itemCount: workertransactions.length,
                              itemBuilder: (BuildContext ctx, int position) {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: MediaQuery.of(context).size.height / 9,
                                  child: Column(
                                    children: <Widget>[
                                      Text('QrCode : ${workertransactions[position]['uid'].toString()}'),
                                      Text('liters : ${workertransactions[position]['liters'].toString()}'),
                                      Text('price :${workertransactions[position]['price'].toString()}'),
                                      Divider(height: 1,color: Colors.grey,),
                                      SizedBox(height: 5,),

                                    ],
                                  ),
                                );
                              })),
            )),
      ),
    );
  }
}
