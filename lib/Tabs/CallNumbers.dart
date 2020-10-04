import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../providerClass.dart';

// ignore: camel_case_types
class Numbers_Call extends StatefulWidget {
  @override
  _Numbers_CallState createState() => _Numbers_CallState();
}

// ignore: camel_case_types
class _Numbers_CallState extends State<Numbers_Call> {
  Color buttonColor = Colors.black54;
  Color textColorbtn = Colors.white;

  _initCall(optCall) async {
    if(optCall == 0){
      call("71665710");
    }
    if (optCall == 1) {
      call("3232347");
    }
    if (optCall == 2) {
      call("1800100");
    }
    if (optCall == 3) {
      call("110");
    }
    if (optCall == 4) {
      call("111");
    }
    if (optCall == 5) {
      call("3202364");
    }
    if (optCall == 6) {
      call("71508000");
    }
    if (optCall == 7) {
      call("1800200");
    }
    if (optCall == 8) {
      call("70908000");
    }
    if (optCall == 9) {
      call("70311573");
    }

  }

  void call(String number) => launch("tel:$number");
  double txtsize = 20;

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(child: Column(
        children: <Widget>[
          Container(
              height: 70,
              child:
              Column(
                children: <Widget>[
                  Container(
                      height: 10,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image:
                              AssetImage("assets/icons/UTX_blk_small_bg.png"),
                          fit: BoxFit.cover,
                        ),
                      )),
                  Align(
                    child: Container(
                        height: 50,
                        child: ListTile(
                          title: Text("ULTIMAX 24/7",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  )),
                          onTap: () {
                            _initCall(0);
                          },
                          leading: ClipRRect(
                              borderRadius: BorderRadius.circular(50.0),
                              child: Image.asset(
                                'assets/icons/UTX247.png',
                                width: 30.0,
                                height: 30.0,
                                fit: BoxFit.cover,
                              )),
                        ),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image:
                                AssetImage("assets/icons/UTX_blk_small_bg.png"),
                            fit: BoxFit.cover,
                          ),
                        )),
                    alignment: Alignment.center,
                  ),
                  Container(
                      height: 10,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/icons/UTX_blk_big_bg.png"),
                          fit: BoxFit.cover,
                        ),
                      )),
                ],
              )),
          Container(
              height: 70,
              child: Column(
                children: <Widget>[
                  Container(
                      height: 10,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image:
                          AssetImage("assets/icons/UTX_blk_small_bg.png"),
                          fit: BoxFit.cover,
                        ),
                      )),
                  Align(
                    child: Container(
                        height: 50,
                        child: ListTile(
                          title: Text("ULTIMAX OFFICE",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                )),
                          onTap: () {
                            _initCall(1);
                          },
                          leading: ClipRRect(
                              borderRadius: BorderRadius.circular(50.0),
                              child: Image.asset(
                                'assets/icons/UTXOffice.png',
                                width: 30.0,
                                height: 30.0,
                                fit: BoxFit.cover,
                              )),
                        ),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image:
                            AssetImage("assets/icons/UTX_blk_small_bg.png"),
                            fit: BoxFit.cover,
                          ),
                        )),
                    alignment: Alignment.center,
                  ),
                  Container(
                      height: 10,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/icons/UTX_blk_big_bg.png"),
                          fit: BoxFit.cover,
                        ),
                      )),
                ],
              )),

          SizedBox(height: 7,),
          Container(
              height: 70,
              child:
              Column(
                children: <Widget>[
                  Container(
                      height: 10,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image:
                          AssetImage("assets/icons/UTX_blue_small_bg.png"),
                          fit: BoxFit.cover,
                        ),
                      )),

                   Container(
                        height: 50,
                        child: ListTile(
                          title: Text("POLICE 24/7",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                 )),
                          onTap: () {
                            _initCall(2);
                          },
                          leading: ClipRRect(
                              borderRadius: BorderRadius.circular(50.0),
                              child: Image.asset(
                                'assets/icons/Police.png',
                                width: 30.0,
                                height: 30.0,
                                fit: BoxFit.cover,
                              )),
                        ),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image:
                            AssetImage("assets/icons/UTX_blue_small_bg.png"),
                            fit: BoxFit.cover,
                          ),
                        ),
                  ),
                  Container(
                      height: 10,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/icons/UTX_blue_big_bg.png"),
                          fit: BoxFit.cover,
                        ),
                      )),
                ],
              )),


          Container(
              height: 70,
              child: Column(
                children: <Widget>[
                  Container(
                      height: 10,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image:
                          AssetImage("assets/icons/UTX_blue_small_bg.png"),
                          fit: BoxFit.cover,
                        ),
                      )),
                  Align(
                    child: Container(
                        height: 50,
                        child: ListTile(
                          title: Text("FIRE SERVICE",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                 )),
                          onTap: () {
                            _initCall(3);
                          },
                          leading: ClipRRect(
                              borderRadius: BorderRadius.circular(50.0),
                              child: Image.asset(
                                'assets/icons/Fire.png',
                                width: 30.0,
                                height: 30.0,
                                fit: BoxFit.cover,
                              )),
                        ),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image:
                            AssetImage("assets/icons/UTX_blue_small_bg.png"),
                            fit: BoxFit.cover,
                          ),
                        )),
                    alignment: Alignment.center,
                  ),
                  Container(
                      height: 10,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/icons/UTX_blue_big_bg.png"),
                          fit: BoxFit.cover,
                        ),
                      )),
                ],
              )),
          Container(
              height: 70,
              child:
              Column(
                children: <Widget>[
                  Container(
                      height: 10,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image:
                          AssetImage("assets/icons/UTX_blue_small_bg.png"),
                          fit: BoxFit.cover,
                        ),
                      )),
                  Align(
                    child: Container(
                        height: 50,
                        child: ListTile(
                          title: Text("ST JOHNS AMBULANCE",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  )),
                          onTap: () {
                            _initCall(4);
                          },
                          leading: ClipRRect(
                              borderRadius: BorderRadius.circular(50.0),
                              child: Image.asset(
                                'assets/icons/Ambulance.png',
                                width: 30.0,
                                height: 30.0,
                                fit: BoxFit.cover,
                              )),
                        ),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image:
                            AssetImage("assets/icons/UTX_blue_small_bg.png"),
                            fit: BoxFit.cover,
                          ),
                        )),
                    alignment: Alignment.center,
                  ),
                  Container(
                      height: 10,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/icons/UTX_blue_big_bg.png"),
                          fit: BoxFit.cover,
                        ),
                      )),
                ],
              )),


          Container(
              height: 70,
              child: Column(
                children: <Widget>[
                  Container(
                      height: 10,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image:
                          AssetImage("assets/icons/UTX_blue_small_bg.png"),
                          fit: BoxFit.cover,
                        ),
                      )),
                  Align(
                    child: Container(
                        height: 50,
                        child: ListTile(
                          title: Text("FAMILY VIOLENCE",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  )),
                          onTap: () {
                            _initCall(5);
                          },
                          leading: ClipRRect(
                              borderRadius: BorderRadius.circular(50.0),
                              child: Image.asset(
                                'assets/icons/familyViolence.png',
                                width: 30.0,
                                height: 30.0,
                                fit: BoxFit.cover,
                              )),
                        ),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image:
                            AssetImage("assets/icons/UTX_blue_small_bg.png"),
                            fit: BoxFit.cover,
                          ),
                        )),
                    alignment: Alignment.center,
                  ),
                  Container(
                      height: 10,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/icons/UTX_blue_big_bg.png"),
                          fit: BoxFit.cover,
                        ),
                      )),
                ],
              )),
          Container(
              height: 70,
              child:
              Column(
                children: <Widget>[
                  Container(
                      height: 10,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image:
                          AssetImage("assets/icons/UTX_blue_small_bg.png"),
                          fit: BoxFit.cover,
                        ),
                      )),
                  Align(
                    child: Container(
                        height: 50,
                        child: ListTile(
                          title: Text("POLICE ABUSE HOTLINE",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                 )),
                          onTap: () {
                            _initCall(6);
                          },
                          leading: ClipRRect(
                              borderRadius: BorderRadius.circular(50.0),
                              child: Image.asset(
                                'assets/icons/PoliceAbuse.png',
                                width: 30.0,
                                height: 30.0,
                                fit: BoxFit.cover,
                              )),
                        ),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image:
                            AssetImage("assets/icons/UTX_blue_small_bg.png"),
                            fit: BoxFit.cover,
                          ),
                        )),
                    alignment: Alignment.center,
                  ),
                  Container(
                      height: 10,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/icons/UTX_blue_big_bg.png"),
                          fit: BoxFit.cover,
                        ),
                      )),
                ],
              )),


          Container(
              height: 70,
              child: Column(
                children: <Widget>[
                  Container(
                      height: 10,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image:
                          AssetImage("assets/icons/UTX_blue_small_bg.png"),
                          fit: BoxFit.cover,
                        ),
                      )),
                  Align(
                    child: Container(
                        height: 50,
                        child: ListTile(
                          title: Text("COVID-19 HOTLINE",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                 )),
                          onTap: () {
                            _initCall(7);
                          },
                          leading: ClipRRect(
                              borderRadius: BorderRadius.circular(50.0),
                              child: Image.asset(
                                'assets/icons/Covid_logo.png',
                                width: 30.0,
                                height: 30.0,
                                fit: BoxFit.cover,
                              )),
                        ),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image:
                            AssetImage("assets/icons/UTX_blue_small_bg.png"),
                            fit: BoxFit.cover,
                          ),
                        )),
                    alignment: Alignment.center,
                  ),
                  Container(
                      height: 10,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/icons/UTX_blue_big_bg.png"),
                          fit: BoxFit.cover,
                        ),
                      )),
                ],
              )),
          Container(
              height: 70,
              child:
              Column(
                children: <Widget>[
                  Container(
                      height: 10,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image:
                          AssetImage("assets/icons/UTX_blue_small_bg.png"),
                          fit: BoxFit.cover,
                        ),
                      )),
                  Align(
                    child: Container(
                        height: 50,
                        child: ListTile(
                          title: Text("PNG POWER",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              )),
                          onTap: () {
                            _initCall(8);
                          },
                          leading: ClipRRect(
                              borderRadius: BorderRadius.circular(50.0),
                              child: Image.asset(
                                'assets/icons/pngpower.jpeg',
                                width: 30.0,
                                height: 30.0,
                                fit: BoxFit.cover,
                              )),
                        ),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image:
                            AssetImage("assets/icons/UTX_blue_small_bg.png"),
                            fit: BoxFit.cover,
                          ),
                        )),
                    alignment: Alignment.center,
                  ),
                  Container(
                      height: 10,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/icons/UTX_blue_big_bg.png"),
                          fit: BoxFit.cover,
                        ),
                      )),
                ],
              )),


          Container(
              height: 70,
              child: Column(
                children: <Widget>[
                  Container(
                      height: 10,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image:
                          AssetImage("assets/icons/UTX_blue_small_bg.png"),
                          fit: BoxFit.cover,
                        ),
                      )),
                  Align(
                    child: Container(
                        height: 50,
                        child: ListTile(
                          title: Text("EDA RANU",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              )),
                          onTap: () {
                            _initCall(9);
                          },
                          leading: ClipRRect(
                              borderRadius: BorderRadius.circular(50.0),
                              child: Image.asset(
                                'assets/icons/water.png',
                                width: 30.0,
                                height: 30.0,
                                fit: BoxFit.cover,
                              )),
                        ),
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image:
                            AssetImage("assets/icons/UTX_blue_small_bg.png"),
                            fit: BoxFit.cover,
                          ),
                        )),
                    alignment: Alignment.center,
                  ),
                  Container(
                      height: 10,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/icons/UTX_blue_big_bg.png"),
                          fit: BoxFit.cover,
                        ),
                      )),
                ],
              )),


        ],
      ),
    ));
  }
}
