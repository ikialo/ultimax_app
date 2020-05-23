import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MessageFromAdmin extends StatefulWidget {
  final String currentUserId;

  MessageFromAdmin({Key key, @required this.currentUserId}) : super(key: key);

  @override
  _MessageFromAdminState createState() => _MessageFromAdminState(currentUserId: currentUserId);
}



class _MessageFromAdminState extends State<MessageFromAdmin> {
  String warningMessage;

  _MessageFromAdminState({Key key, @required this.currentUserId});

  var listMessage;
  SharedPreferences prefs ;
  String id;
  final String currentUserId;

  Future<void> getPrefs() async {
    prefs = await SharedPreferences.getInstance();

    setState(() {
      id = prefs.getString("id");
    });
  }




  Widget buildListMessageWarn() {
    return Flexible(
      child: StreamBuilder(
        stream: Firestore.instance
            .collection('warnusers')
            .document(id)
//            .document("messbo")
//            .collection("messbo")
//            .orderBy('timestamp', descending: true)
//
//            .limit(500)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: CircularProgressIndicator(
                    valueColor:
                    AlwaysStoppedAnimation<Color>(Colors.black)));
          } else {
            listMessage = snapshot.data.documents;
            return ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemBuilder: (context, index) =>
                  buildItem(index, snapshot.data.documents[index]),
              itemCount: snapshot.data.documents.length,
              reverse: false,
              //controller: listScrollController,
            );
          }
        },
      ),
    );
  }


  Widget buildItem(index, document){

    return Container(child: Text(document["warning Message"]));

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getPrefs();
    getMessageWarning();
  }
  Future<void> getMessageWarning () async {
    await Firestore.instance.collection("users").document(currentUserId).get().then((doc){

      setState(() {
        warningMessage =doc["warningMessage"];


      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(title: Text("Message From Admin")),
      body: SafeArea(child: Stack(children: <Widget>[

       Card(
         child: ListTile(
           isThreeLine: false,

           title: Text(warningMessage == null? "no message from admin": warningMessage),
           leading: Icon(Icons.warning),

         ))
        //buildListMessageWarn(),


      ],))
    );
  }
}
