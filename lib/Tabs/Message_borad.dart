import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Message_board extends StatefulWidget {
  @override
  _Message_boardState createState() => _Message_boardState();
}

class _Message_boardState extends State<Message_board> {
  final databaseReference = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
                child: ListView.builder(
                  reverse: true,
                  padding: EdgeInsets.only(top: 15.0),
                  itemCount:20,
                  itemBuilder: (BuildContext context, int index) {

                    return _buildMessage("message what if this is a longer senesternce will it go to next link", true);
                  },
                ),
              ),
            ),
          ),
          _buildMessageComposer(),
        ],
      ),
    );
//        body: Column(
//      children: <Widget>[
//        Container(child: SizedBox(width: double.infinity,height: 500,),
//          color: Colors.yellow,
//
//        ),
//        Expanded(
//
//          child: Align(
//
//            alignment: FractionalOffset.bottomCenter,
//            child: TextField(
//                keyboardType: TextInputType.multiline,
//                minLines: 1,
//                maxLines: null,
//              autocorrect: true,
//              decoration: InputDecoration(
//                hintText: 'Type Text Here...',
//                hintStyle: TextStyle(color: Colors.grey),
//                filled: true,
//                fillColor: Colors.white70,
//                enabledBorder: OutlineInputBorder(
//                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
//                  borderSide: BorderSide(color: Colors.blue, width: 2),
//                ),
//                focusedBorder: OutlineInputBorder(
//                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
//                  borderSide: BorderSide(color: Colors.red),
//                ),
//              ),
//            ),
//          ),
//        ),
//        SizedBox(width: double.infinity,height: 5,)
//      ],
//    )
  }

  void createRecord() async {
    await databaseReference.collection("books").document("1").setData({
      'title': 'Mastering Flutter',
      'description': 'Programming Guide for Dart'
    });

    DocumentReference ref = await databaseReference.collection("books").add({
      'title': 'Flutter in Action',
      'description': 'Complete Programming Guide to learn Flutter'
    });
    print(ref.documentID);
  }

  void getData() {
    databaseReference
        .collection("books")
        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) => print('${f.data}}'));
    });
  }

  void updateData() {
    try {
      databaseReference
          .collection('books')
          .document('1')
          .updateData({'description': 'Head First Flutter'});
    } catch (e) {
      print(e.toString());
    }
  }

  void deleteData() {
    try {
      databaseReference.collection('books').document('1').delete();
    } catch (e) {
      print(e.toString());
    }
  }

  _buildMessage(String message, bool isMe) {
    final Container msg = Container(
      margin: isMe
          ? EdgeInsets.only(
        top: 8.0,
        bottom: 8.0,
        left: 80.0,
      )
          : EdgeInsets.only(
        top: 8.0,
        bottom: 8.0,
      ),
      padding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
      width: MediaQuery.of(context).size.width * 0.75,
      decoration: BoxDecoration(
        color: isMe ? Theme.of(context).accentColor : Color(0xFFFFEFEE),
        borderRadius: isMe
            ? BorderRadius.only(
          topLeft: Radius.circular(15.0),
          bottomLeft: Radius.circular(15.0),
        )
            : BorderRadius.only(
          topRight: Radius.circular(15.0),
          bottomRight: Radius.circular(15.0),
        ),
      ),
      child:

          Text(
            message,
            style: TextStyle(
              color: Colors.blueGrey,
              fontSize: 16.0,
              fontWeight: FontWeight.w600,
            ),
          ),

    );
    if (isMe) {
      return msg;
    }
    return Row(
      children: <Widget>[
        msg,
        IconButton(
          icon: Icon(Icons.favorite_border),
          iconSize: 30.0,
          color: Colors.blueGrey,
          onPressed: () {},
        )
      ],
    );
  }


  _buildMessageComposer() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0),
      height: 70.0,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.attach_file),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () {


              final snackBar = SnackBar(
                content: Text('Yay! A SnackBar!'),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () {
                    // Some code to undo the change.
                  },
                ),
              );

              // Find the Scaffold in the widget tree and use
              // it to show a SnackBar.
              Scaffold.of(context).showSnackBar(snackBar);
            },
          ),
          Expanded(
            child: TextField(
              textCapitalization: TextCapitalization.sentences,
              onChanged: (value) {},
              decoration: InputDecoration.collapsed(
                hintText: 'Send a message...',
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.send),
            iconSize: 25.0,
            color: Theme.of(context).primaryColor,
            onPressed: () {

              final snackBar = SnackBar(
                content: Text('Yay! A SnackBar!'),
                action: SnackBarAction(
                  label: 'Undo',
                  onPressed: () {
                    // Some code to undo the change.
                  },
                ),
              );

              // Find the Scaffold in the widget tree and use
              // it to show a SnackBar.
              Scaffold.of(context).showSnackBar(snackBar);
            },
          ),
        ],
      ),
    );
  }

}

class SnackBarPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        onPressed: () {
          final snackBar = SnackBar(
            content: Text('Yay! A SnackBar!'),
            action: SnackBarAction(
              label: 'Undo',
              onPressed: () {
                // Some code to undo the change.
              },
            ),
          );

          // Find the Scaffold in the widget tree and use
          // it to show a SnackBar.
          Scaffold.of(context).showSnackBar(snackBar);
        },
        child: Text('Show SnackBar'),
      ),
    );
  }
}