import 'package:call_number/call_number.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class Numbers_Call extends StatefulWidget {
  @override
  _Numbers_CallState createState() => _Numbers_CallState();
}

// ignore: camel_case_types
class _Numbers_CallState extends State<Numbers_Call> {
  _initCall(call) async {
    await new CallNumber().callNumber("70875993");

    if (call == 1) {
      await new CallNumber().callNumber("1800100");
    }
    if (call == 2) {
      await new CallNumber().callNumber("110");
    }
    if (call == 3) {
      await new CallNumber().callNumber("000");
    }
    if (call == 4) {
      await new CallNumber().callNumber("1800200");
    }
    if (call == 5) {
      await new CallNumber().callNumber("3202364");
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
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
              FlatButton(
                child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(8.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(2),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(50.0),
                            child: Image.asset(
                              'assets/icons/google_icon.png',
                              width: 30.0,
                              height: 30.0,
                              fit: BoxFit.cover,
                            )),
                      ),
                      Text("POLICE",
                          style: TextStyle(color: Colors.blueGrey, fontSize: 30)),
                    ],
                  ),
                ),
                onPressed: () {
                  _initCall(1);
                },
              ),
              FlatButton(
                child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(8.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(50.0),
                            child: Image.asset(
                              'assets/icons/google_icon.png',
                              width: 30.0,
                              height: 30.0,
                              fit: BoxFit.cover,
                            )),
                      ),
                      Text("FIRE SERVICE",
                          style: TextStyle(color: Colors.blueGrey, fontSize: 30)),
                    ],
                  ),
                ),
                onPressed: () {
                  _initCall(2);
                },
              ),
              FlatButton(
                child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(8.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(50.0),
                            child: Image.asset(
                              'assets/icons/google_icon.png',
                              width: 30.0,
                              height: 30.0,
                              fit: BoxFit.cover,
                            )),
                      ),
                      Text("AMBULANCE",
                          style: TextStyle(color: Colors.blueGrey, fontSize: 30)),
                    ],
                  ),
                ),
                onPressed: () {
                  _initCall(3);
                },
              ),
              FlatButton(
                splashColor: Colors.yellow,
                child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(8.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(50.0),
                            child: Image.asset(
                              'assets/icons/photo.jpg',
                              width: 40.0,
                              height: 40.0,
                              fit: BoxFit.cover,
                            )),
                      ),
                      Text("ULTIMAX",
                          style: TextStyle(color: Colors.blueGrey, fontSize: 30)),
                    ],
                  ),
                ),
                onPressed: () {
                  _initCall(3);
                },
              ), FlatButton(
              splashColor: Colors.yellow,
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(8.0)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(5),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(50.0),
                          child: Image.asset(
                            'assets/icons/photo.jpg',
                            width: 40.0,
                            height: 40.0,
                            fit: BoxFit.cover,
                          )),
                    ),
                    Text("COVID 19 HOTLINE",
                        style: TextStyle(color: Colors.blueGrey, fontSize: 20)),
                  ],
                ),
              ),
              onPressed: () {
                _initCall(4);
              },
            ),

              FlatButton(
                splashColor: Colors.yellow,
                child: Container(
                  height: 70,
                  decoration: BoxDecoration(
                      color: Colors.yellow,
                      borderRadius: BorderRadius.circular(8.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(5),
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(50.0),
                            child: Image.asset(
                              'assets/icons/photo.jpg',
                              width: 40.0,
                              height: 40.0,
                              fit: BoxFit.cover,
                            )),
                      ),
                      Text("POLICE ABUSE HOTLINE",
                          style: TextStyle(color: Colors.blueGrey, fontSize: 20)),
                    ],
                  ),
                ),
                onPressed: () {
                  _initCall(5);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
