 import 'package:flutter/material.dart';

import 'confirm_efuel.dart';
import 'transactions.dart';
import 'profile/profile_page.dart';


class Main_Screen extends StatefulWidget {


  Main_Screen();

  @override
  _Main_ScreenState createState() => _Main_ScreenState();
}

class _Main_ScreenState extends State<Main_Screen>{

  @override

  Widget build(BuildContext context) {

    return MaterialApp(

      debugShowCheckedModeBanner: false,

      home: DefaultTabController(

        initialIndex: 1,

        length: 3,

        child: Scaffold(

          appBar: AppBar(

            backgroundColor: Color(0xff003680),

            title: Text("Perfect ..Confirm Fill "),

            centerTitle: true,

          ),

          bottomNavigationBar: menu(),

          body: Container(
// bottom tabs , profile ,Confirm fill and profile
             child: TabBarView(

               children: [
                 Transactions(),

                 confirm_efuel(),


                 Profile()

               ],

             ),

          ),

        ),

      ),

    );

  }

  Widget menu() {

    return Container(

      color: Colors.white,

      child: TabBar(

        labelStyle: TextStyle(fontSize:8),

        labelColor: Colors.orange,

        unselectedLabelColor: Colors.grey,

        indicatorPadding: EdgeInsets.only(right: 5),

        indicatorColor: Colors.white,

        tabs: [
// bottom images and icons , profile ,Confirm fill and profile


          Tab(

            text: "Transactions",
            icon: Icon(Icons.announcement),

           ),
          Tab(
            text: "Fill Fuel",
            icon: Image.asset("assets/gas_station.png",height: 25,color: Colors.grey.withOpacity(.5)),


          ),
          Tab(

            text: "profile",
            icon: Icon(Icons.person_pin,color: Colors.grey,)

          ),




        ],

      ),

    );

  }

}


