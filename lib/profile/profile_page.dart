import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:efuel_worker/loader.dart';
import 'package:efuel_worker/profile/settings.dart';
import 'package:efuel_worker/profile/update_profile.dart';
  import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
 import 'package:shared_preferences/shared_preferences.dart';
 import 'package:http/http.dart'as http;
 import 'change_password.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  File ImgPath;
String auth,photo;


// getting image from gallery
  void Image_picker() async {
    File img;
    img = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      ImgPath = img;
      if(ImgPath!=null){
        // upload choosen image to server
        upload_file(img, context);

      }
      else {

      }

    });

  }
  void log_out()async{
     SharedPreferences.getInstance().then((pref){
       pref.clear();
       exit(0);
       Navigator.of(context).pop();
     });

    //Navigator.of(context).pop();

  }
// upload image to server
  Future<String> upload_file(File file_src,BuildContext context) async {
 

    if(file_src==null){

    }
    else {
      Dio dio = Dio();
      FormData formData = FormData.fromMap({
        "photo": await MultipartFile.fromFile("${file_src.path}",
            filename: "${file_src.path.split('/').last}"),
      });

      var response = await dio.post(
          "https://app.efuel-app.com/public/api/update_profile",
          data: formData,options: Options(headers: {
        HttpHeaders.authorizationHeader:auth
      })).then((response){
         print("wwssddaaaa${response.data}");
        return response.toString();
      });

    }

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
      photo=json.decode(response.body)['photo'];
      });



  }
  // getting user auth from database

  void getauth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      auth = prefs.getString("efuelworker_auth");
    });
    get_profile();
  }

  @override
  void initState() {
    super.initState();
    getauth();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: GestureDetector(
                  onTap: () {
                    Image_picker();
                  },
                  child: CircleAvatar(
                    radius: 35,
                    child: ImgPath == null && photo == null
                        ? Image.asset("assets/choose_image.png")
                        : photo == null?Container(
                            width: 140.0,
                            height: 140.0,
                            decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                image: FileImage(ImgPath),
                                fit: BoxFit.cover,
                              ),
                            )):Container(
                        width: 140.0,
                        height: 140.0,
                        decoration: new BoxDecoration(
                          shape: BoxShape.circle,
                          image: new DecorationImage(
                            image:NetworkImage("https://app.efuel-app.com/public/storage/${photo}"),
                            fit: BoxFit.cover,
                          ),
                        )),
                    backgroundColor: Colors.transparent,
                  )),
            ),
//            Padding(
//              padding: const EdgeInsets.only(top: 8, bottom: 8),
//              child: Text("mahomoud"),
//            ),
//            Padding(
//              padding: const EdgeInsets.only(bottom: 20),
//              child: Text("mahomoud@gmail.com "),
//            ),
            ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Update_profile(),
                  ),
                );
              },
              title: Text(
                "Edit Profile",
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => change_password(),
                  ),
                );
              },
              title: Text(
                "Change Password",
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Settings(),
                  ),
                );
              },
              title: Text(
                "Settings",
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
//                Navigator.push(
//                  context,
//                  MaterialPageRoute(
//                    builder: (context) => Webview_terma("https://app.efuel-app.com/api/about_en"),
//                  ),
//                );
              },
              title: Text(
                "About E-Fuel",
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
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) => AlertDialog(
                      content: ListTile(
                        title: Text("are you sure you want to exit ?!"),
                      ),
                      actions: <Widget>[
                        FlatButton(
                          child: Text('yes'),
                          onPressed: (){
                            log_out();

                          },
                        ),
                        FlatButton(
                          child: Text('cancel'),
                          onPressed: () {
                            print('Tappped');
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ));
              },
              title: Text(
                "Sign Out",
                style: TextStyle(
                  color: Color.fromRGBO(4, 54, 105, 1),
                ),
              ),
              trailing: Icon(Icons.exit_to_app),
            ),

            Container(
              child: Divider(
                height: 1,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
