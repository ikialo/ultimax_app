import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ultimax2/DialogNotice/dialog_content.dart';

class Notification_alert extends StatefulWidget {
  @override
  _NotificationState createState() => _NotificationState();
}

class _NotificationState extends State<Notification_alert> {
  SharedPreferences prefs;
  var listMessage;
  final ScrollController listScrollController = new ScrollController();
  final TextEditingController textEditingController =
      new TextEditingController();
  bool admin;
  File imageFile;

  bool isLoading;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    admin = false;
    isLoading = false;
    setPrefs();
  }

  void setPrefs() async {
    prefs = await SharedPreferences.getInstance();

    setState(() {
      admin = prefs.getBool("admin");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              // List of messages
              buildListMessage(),

              // Sticker

              // Input content
            ],
          ),
        ],
      ),
      floatingActionButton: admin == true
          ? FloatingActionButton(
        child: Icon(Icons.add,color: Colors.white,),
              onPressed: () {
                dialogbox_notice();
              },
              backgroundColor: Colors.black54,
        elevation: 30,
            )
          : Container(),
    );
  }

  Widget buildListMessage() {
    return Flexible(
      child: StreamBuilder(
        stream: Firestore.instance
            .collection('Notice')
            .document("Notice_")
            .collection("Ultimax")
            .orderBy('timestamp', descending: true)
            .limit(500)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.yellow)));
          } else {
            listMessage = snapshot.data.documents;
            return ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemBuilder: (context, index) =>
                  buildItem(index, snapshot.data.documents[index]),
              itemCount: snapshot.data.documents.length,
              reverse: true,
              controller: listScrollController,
            );
          }
        },
      ),
    );
  }

  Widget buildItem(int index, DocumentSnapshot document) {
    // Right (my message)
    return GestureDetector(
        child: Padding(
            padding: EdgeInsets.all(4.0),
            child: Card(

//              decoration: BoxDecoration(
//                  color: Colors.grey,
//                  borderRadius: BorderRadius.circular(8.0)),
//              margin: EdgeInsets.only(left: 10.0),
              child: Column(
                // Decides which type of post it is and shows accordingly
                children: <Widget>[
                  Column(children: <Widget>[
                    // Image

                    document["attachment"] != "no_image"?
                    Padding(
                        padding: EdgeInsets.only(top: 8.0),
                        child: Container(
                          child: FlatButton(
                            child: Material(
                              child: CachedNetworkImage(
                                placeholder: (context, url) => Container(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.yellow),
                                  ),
                                  width: 200.0,
                                  height: 200.0,
                                  padding: EdgeInsets.all(70.0),
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8.0),
                                    ),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Material(
                                  child: Image.asset(
                                    'images/img_not_available.jpeg',
                                    width: 200.0,
                                    height: 200.0,
                                    fit: BoxFit.cover,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8.0),
                                  ),
                                  clipBehavior: Clip.hardEdge,
                                ),
                                imageUrl: document['attachment'],
                                width: 200.0,
                                height: 200.0,
                                fit: BoxFit.cover,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0)),
                              clipBehavior: Clip.hardEdge,
                            ),
                            onPressed: () {},
                            padding: EdgeInsets.all(0),
                          ),
                          margin: EdgeInsets.only(bottom: 10.0, right: 10.0),
                        )): Container(),
                    Container(
                      child: Text(
                        document['content'],
                        style: TextStyle(color: Colors.white),
                      ),
                      padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                      width: 300.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0)),
                      margin: EdgeInsets.only(bottom: 10.0, right: 10.0),
                    )
                    // Sticker
                  ], mainAxisAlignment: MainAxisAlignment.start),

                  // TIme under the messages
                  Container(
                    child: Text(
                      DateFormat('dd MMM kk:mm').format(
                          DateTime.fromMillisecondsSinceEpoch(
                              int.parse(document['timestamp']))),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 12.0,
                          fontFamily: "HANDGOTN",
                          fontStyle: FontStyle.italic),
                    ),
                    margin: EdgeInsets.only(left: 50.0, top: 5.0, bottom: 5.0),
                  )
                ],
              ), color: Colors.grey, elevation: 10, borderOnForeground: true,
            )));
  }

  void dialogbox_notice() {
    alertDialog(Dialog_content(), "Create Notice");
  }

  Future<void> alertDialog(popup, opt) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(1.0),
          elevation: 8.0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0))),
          title: Text(
            opt,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
          content: popup,
        );
      },
    );
  }
}
