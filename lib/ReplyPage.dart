import 'package:flutter/material.dart';


class ReplyPage extends StatefulWidget {

  final String message;
  final String senderID;

  ReplyPage({Key key, @required this.message, @required this.senderID})
      : super(key: key);

  @override
  State createState() =>
      new _ReplyPageState(message: message, senderID: senderID);
}

class _ReplyPageState extends State<ReplyPage> {
  _ReplyPageState({Key key, @required this.message, @required this.senderID});


  String message;
  String senderID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(title: Text("Reply"), backgroundColor: Colors.blue,),
      body: Center(child: Text(message != ""? message: "no message"),)
    );
  }
}
