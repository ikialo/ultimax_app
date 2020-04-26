import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// ignore: camel_case_types
class Numbers_Call extends StatefulWidget {
  @override
  _Numbers_CallState createState() => _Numbers_CallState();
}

// ignore: camel_case_types
class _Numbers_CallState extends State<Numbers_Call> {
  Color buttonColor = Colors.amber;
  Color textColorbtn = Colors.white;

  _initCall(optCall) async {
    if (optCall == 1) {
      call("1800100");
    }
    if (optCall == 2) {
      call("110");
    }
    if (optCall == 3) {
      call("000");
    }
    if (optCall == 4) {
      call("1800200");
    }
    if (optCall == 5) {
      call("3202364");
    }
  }

  void call(String number) => launch("tel:$number");
  double txtsize = 20;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          title: Text(
            'Emergency Contacts',
            style: TextStyle(color: Colors.yellow),
          ),
          backgroundColor: Colors.yellow,
          expandedHeight: 150.0,
          flexibleSpace: FlexibleSpaceBar(
            background:
                Image.asset('assets/icons/photo.jpg', fit: BoxFit.cover),
          ),
        ),
        SliverFixedExtentList(
          itemExtent: 72.0,
          delegate: SliverChildListDelegate(
            [
              Card(
                child: Padding(
                  child: ListTile(
                    title: Text("POLICE",
                        style:
                            TextStyle(color: textColorbtn, fontSize: txtsize)),
                    onTap: () {
                      _initCall(1);
                    },
                    leading: ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: Image.asset(
                          'assets/icons/google_icon.png',
                          width: 30.0,
                          height: 30.0,
                          fit: BoxFit.cover,
                        )),
                  ),
                  padding: EdgeInsets.all(8),
                ),
                color: buttonColor,
              ),

              Card(
                child: Padding(
                  child: ListTile(
                    title: Text("Fire Service",
                        style:
                            TextStyle(color: textColorbtn, fontSize: txtsize)),
                    onTap: () {
                      _initCall(2);
                    },
                    leading: ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: Image.asset(
                          'assets/icons/google_icon.png',
                          width: 30.0,
                          height: 30.0,
                          fit: BoxFit.cover,
                        )),
                  ),
                  padding: EdgeInsets.all(8),
                ),
                color: buttonColor,
              ),
              Card(
                child: Padding(
                  child: ListTile(
                    title: Text("Ambulance",
                        style:
                            TextStyle(color: textColorbtn, fontSize: txtsize)),
                    onTap: () {
                      _initCall(3);
                    },
                    leading: ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: Image.asset(
                          'assets/icons/google_icon.png',
                          width: 30.0,
                          height: 30.0,
                          fit: BoxFit.cover,
                        )),
                  ),
                  padding: EdgeInsets.all(8),
                ),
                color: buttonColor,
              ),
              Card(
                child: Padding(
                  child: ListTile(
                    title: Text("COVID-19 HOTLINE",
                        style:
                            TextStyle(color: textColorbtn, fontSize: txtsize)),
                    onTap: () {
                      _initCall(4);
                    },
                    leading: ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: Image.asset(
                          'assets/icons/google_icon.png',
                          width: 30.0,
                          height: 30.0,
                          fit: BoxFit.cover,
                        )),
                  ),
                  padding: EdgeInsets.all(8),
                ),
                color: buttonColor,
              ),
              Card(
                child: Padding(
                  child: ListTile(
                    title: Text("POLICE ABUSE HOTLINE",
                        style:
                            TextStyle(color: textColorbtn, fontSize: txtsize)),
                    onTap: () {
                      _initCall(5);
                    },
                    leading: ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: Image.asset(
                          'assets/icons/google_icon.png',
                          width: 30.0,
                          height: 30.0,
                          fit: BoxFit.cover,
                        )),
                  ),
                  padding: EdgeInsets.all(8),
                ),
                color: buttonColor,
              ),
              Card(
                child: Padding(
                  child: ListTile(
                    title: Text("ULTIMAX",
                        style:
                            TextStyle(color: textColorbtn, fontSize: txtsize)),
                    onTap: () {
                      _initCall(1);
                    },
                    leading: ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: Image.asset(
                          'assets/icons/google_icon.png',
                          width: 30.0,
                          height: 30.0,
                          fit: BoxFit.cover,
                        )),
                  ),
                  padding: EdgeInsets.all(8),
                ),
                color: buttonColor,
              ),
//              FlatButton(
//                child: Container(
//                  height: 70,
//                  decoration: BoxDecoration(
//                      color: buttonColor,
//                      borderRadius: BorderRadius.circular(8.0)),
//                  child: Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                    children: <Widget>[
//                      Padding(
//                        padding: EdgeInsets.all(5),
//                        child: ClipRRect(
//                            borderRadius: BorderRadius.circular(50.0),
//                            child: Image.asset(
//                              'assets/icons/google_icon.png',
//                              width: 30.0,
//                              height: 30.0,
//                              fit: BoxFit.cover,
//                            )),
//                      ),
//                      Text("FIRE SERVICE",
//                          style: TextStyle(color: textColorbtn, fontSize: 30)),
//                    ],
//                  ),
//                ),
//                onPressed: () {
//                  _initCall(2);
//                },
//              ),
//              FlatButton(
//                child: Container(
//                  height: 70,
//                  decoration: BoxDecoration(
//                      color: buttonColor,
//                      borderRadius: BorderRadius.circular(8.0)),
//                  child: Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                    children: <Widget>[
//                      Padding(
//                        padding: EdgeInsets.all(5),
//                        child: ClipRRect(
//                            borderRadius: BorderRadius.circular(50.0),
//                            child: Image.asset(
//                              'assets/icons/google_icon.png',
//                              width: 30.0,
//                              height: 30.0,
//                              fit: BoxFit.cover,
//                            )),
//                      ),
//                      Text("AMBULANCE",
//                          style: TextStyle(color: textColorbtn, fontSize: 30)),
//                    ],
//                  ),
//                ),
//                onPressed: () {
//                  _initCall(3);
//                },
//              ),
//              FlatButton(
//                splashColor: buttonColor,
//                child: Container(
//                  height: 70,
//                  decoration: BoxDecoration(
//                      color: buttonColor,
//                      borderRadius: BorderRadius.circular(8.0)),
//                  child: Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                    children: <Widget>[
//                      Padding(
//                        padding: EdgeInsets.all(5),
//                        child: ClipRRect(
//                            borderRadius: BorderRadius.circular(50.0),
//                            child: Image.asset(
//                              'assets/icons/photo.jpg',
//                              width: 40.0,
//                              height: 40.0,
//                              fit: BoxFit.cover,
//                            )),
//                      ),
//                      Text("ULTIMAX",
//                          style: TextStyle(color: textColorbtn, fontSize: 30)),
//                    ],
//                  ),
//                ),
//                onPressed: () {
//                  _initCall(3);
//                },
//              ),
//              FlatButton(
//                splashColor: Colors.yellow,
//                child: Container(
//                  height: 70,
//                  decoration: BoxDecoration(
//                      color: buttonColor,
//                      borderRadius: BorderRadius.circular(8.0)),
//                  child: Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                    children: <Widget>[
//                      Padding(
//                        padding: EdgeInsets.all(5),
//                        child: ClipRRect(
//                            borderRadius: BorderRadius.circular(50.0),
//                            child: Image.asset(
//                              'assets/icons/photo.jpg',
//                              width: 40.0,
//                              height: 40.0,
//                              fit: BoxFit.cover,
//                            )),
//                      ),
//                      Text("COVID 19 HOTLINE",
//                          style: TextStyle(color: textColorbtn, fontSize: 20)),
//                    ],
//                  ),
//                ),
//                onPressed: () {
//                  _initCall(4);
//                },
//              ),
//              FlatButton(
//                splashColor: Colors.yellow,
//                child: Container(
//                  height: 70,
//                  decoration: BoxDecoration(
//                      color: buttonColor,
//                      borderRadius: BorderRadius.circular(8.0)),
//                  child: Row(
//                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                    children: <Widget>[
//                      Padding(
//                        padding: EdgeInsets.all(5),
//                        child: ClipRRect(
//                            borderRadius: BorderRadius.circular(50.0),
//                            child: Image.asset(
//                              'assets/icons/photo.jpg',
//                              width: 40.0,
//                              height: 40.0,
//                              fit: BoxFit.cover,
//                            )),
//                      ),
//                      Text("POLICE ABUSE HOTLINE",
//                          style: TextStyle(color: textColorbtn, fontSize: 20)),
//                    ],
//                  ),
//                ),
//                onPressed: () {
//                  _initCall(5);
//                },
//              ),
            ],
          ),
        ),
      ],
    ));
  }
}
