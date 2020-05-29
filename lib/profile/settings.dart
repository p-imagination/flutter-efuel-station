import 'dart:io';

 import 'package:efuel_worker/webview_terms.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
 import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[

              Container(
                child: Divider(
                  height: 1,
                  color: Colors.black,
                ),
              ),
              ListTile(
                onTap: (){
                  // navigate to privacy webview
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Webview_terma("https://app.efuel-app.com/api/privacy_en"),
                    ),
                  );
                },

                title: Text(
                  "Privacy Policy",
                  style: TextStyle(
                    color: Color.fromRGBO(4, 54, 105, 1),
                  ),
                ),
                trailing: Icon(Icons.navigate_next),
              ),
              Container(
                child: Divider(
                  height: 1,
                  color: Colors.black,
                ),
              ),
              ListTile(

                title: Text(
                  "Terms & Conditions",
                  style: TextStyle(
                    color: Color.fromRGBO(4, 54, 105, 1),
                  ),
                ),
                trailing: Icon(Icons.navigate_next),
              ),
              Container(
                child: Divider(
                  height: 1,
                  color: Colors.black,
                ),
              ),
              ListTile(
                onTap: (){
                  share_efuel();
                },
                title: Text(
                  "Share E-fuel",
                  style: TextStyle(
                    color: Color.fromRGBO(4, 54, 105, 1),
                  ),
                ),
                trailing: Icon(Icons.navigate_next),
              ),
              Container(
                child: Divider(
                  height: 1,
                  color: Colors.black,
                ),
              ),
              Platform.isAndroid?    ListTile(

                onTap: (){
                  _rateEfuel();

                },
                title: Text(
                  "Rate E-fuel",
                  style: TextStyle(
                    color: Color.fromRGBO(4, 54, 105, 1),
                  ),
                ),
                trailing: Icon(Icons.navigate_next),
              ):Container(),
              Container(
                child: Divider(
                  height: 1,
                  color: Colors.black,
                ),
              ),


            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Color(0xff003680),

    title: Text("Settings"),
        centerTitle: true,
      ),
    );
  }
// open google play to rate this app
  _rateEfuel() async {
    const url_android =
        "https://play.google.com/store/apps/details?id=efuelworker.efuel_worker";

    const url_ios =
        "https://apps.apple.com/us/app/my-efuel-station/id1496559869?ls=1";
    if (Platform.isAndroid) {
      if (await canLaunch(url_android)) {
        await launch(url_android);
      } else {
        throw 'Could not launch $url_android';
      }

      // Android-specific code
    } else if (Platform.isIOS) {
      if (await canLaunch(url_ios)) {
        await launch(url_ios);
      } else {
        throw 'Could not launch $url_ios';
      }
      // iOS-specific code
    }
  }
  // share app via social media
  void share_efuel() async{
if(Platform.isIOS){
  Share.share('https://apps.apple.com/us/app/my-efuel-station/id1496559869?ls=1');

}
else {
  Share.share('https://play.google.com/store/apps/details?id=efuelworker.efuel_worker');

}


  }
}
