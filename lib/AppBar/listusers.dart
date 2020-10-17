import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ListUsers extends StatefulWidget {
  @override
  _ListUsersState createState() => _ListUsersState();
}

class _ListUsersState extends State<ListUsers> {
  var listMessage;

  var black = Colors.black;
  final TextEditingController textEditingController =
      new TextEditingController();

  int numberOfWarning;

  bool warned;

  Widget buildListMessage() {
    return Flexible(
      child: StreamBuilder(
        stream: Firestore.instance
            .collection('users')
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
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black)));
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

  Widget buildItem(int index, DocumentSnapshot document) {


    if (document['warned']== null){
      warned = false;
    }

//    numberOfWarning = document["warning"];
//
//    if (numberOfWarning == null){
//
//      numberOfWarning = 0;
//
//    }else {
//
//      numberOfWarning = numberOfWarning +1;
//    }
    return Material(
        child: Column(
      children: <Widget>[
        Card(
          elevation: 10,
          child: ListTile(
            leading: Material(
              child: CachedNetworkImage(
                placeholder: (context, url) => Container(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                  padding: EdgeInsets.all(70.0),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.all(
                      Radius.circular(8.0),
                    ),
                  ),
                ),
                errorWidget: (context, url, error) => Material(
                  child: Image.asset(
                    'images/img_not_available.jpeg',
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                  clipBehavior: Clip.hardEdge,
                ),
                imageUrl: document['photoUrl'] != null ?document['photoUrl'] : "https://firebasestorage.googleapis.com/v0/b/ultimax-e4e58.appspot.com/o/icon_ultimax.jpg?alt=media&token=8c623e6d-4d8c-45d8-bf3d-82e0df08ce0f",
                width: 50.0,
                height: 50.0,
                fit: BoxFit.cover,
              ),
              clipBehavior: Clip.hardEdge,
              borderRadius: BorderRadius.all(
                Radius.circular(25.0),
              ),
            ),
            title: Text(document["nickname"] == null ? document.documentID:document["nickname"]),
            onLongPress: () {
              print("delete user");

              openDialog(document, 1);
            },
            onTap: () {


              print("warn user");
              openDialog(document, 0);

//          var documentReference = Firestore.instance
//              .collection('deletedUser')
////              .document(document['id'])
////              .collection("messbo")
//              .document(DateTime.now().millisecondsSinceEpoch.toString());
//
//          Firestore.instance.runTransaction((transaction) async {
//            await transaction.set(
//              documentReference,
//              {
//                'idFrom': document['pushToken'],
//
//              },
//            );
//          });
            },
            trailing:   Icon(warned? Icons.warning: Icons.check),
          ),
        ),
        SizedBox(
          height: 2,
        )
      ],
    ));
  }

  Future<Null> openDialog(DocumentSnapshot document, int opt) async {
    switch (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            contentPadding:
                EdgeInsets.only(left: 0.0, right: 0.0, top: 0.0, bottom: 0.0),
            children: <Widget>[
              Container(
                color: black,
                margin: EdgeInsets.all(0.0),
                padding: EdgeInsets.only(bottom: 10.0, top: 10.0),
                height: 100.0,
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        opt == 1 ? Icons.delete : Icons.warning,
                        size: 30.0,
                        color: Colors.white,
                      ),
                      margin: EdgeInsets.only(bottom: 10.0),
                    ),
                    Text(
                      opt == 0 ? 'Warn User' : "Delete User",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      opt == 0 ? 'Send Users Warning' : "Delete User",
                      style: TextStyle(color: Colors.white70, fontSize: 14.0),
                    ),
                  ],
                ),
              ),
              opt == 0
                  ? TextField(
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: null,
                      style: TextStyle(color: Colors.black, fontSize: 15.0),
                      controller: textEditingController,
                      decoration: InputDecoration.collapsed(
                        hintText: 'Type your message...',
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    )
                  : Container(),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, 0);
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.cancel,
                        color: black,
                      ),
                      margin: EdgeInsets.only(right: 10.0),
                    ),
                    Text(
                      'CANCEL',
                      style:
                          TextStyle(color: black, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              SimpleDialogOption(
                onPressed: () {
                  if (opt == 0) {
                    // warn user
                    if (textEditingController.text.trim() != '') {
                      sendWarning(document, textEditingController.text);
                      textEditingController.clear();
                    } else {
                      Fluttertoast.showToast(msg: "No Message to post");
                    }
                  } else {
                    //delete user

                    deleteUser(document);
                  }
                  Navigator.pop(context, 0);

//                  deleteData(document);
//                  Navigator.pop(context, 1);
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Icon(
                        Icons.check_circle,
                        color: black,
                      ),
                      margin: EdgeInsets.only(right: 10.0),
                    ),
                    Text(
                      'YES',
                      style:
                          TextStyle(color: black, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ],
          );
        })) {
      case 0:
        break;
      case 1:
        break;
    }
  }


  /// test
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    warned = false;

  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text("List of Users"),
            ),
            body: Stack(
              children: <Widget>[
                Align(
                  child: Column(
                    children: <Widget>[
                      // List of messages
                      buildListMessage(),

                      // Sticker

                      // Input content
                    ],
                  ),
                  alignment: Alignment.topCenter,
                ) // Loading
              ],
            )));
  }

  Future<void> sendWarning(document, warningMsg) async {


    print("number of warning : $warningMsg");
//    final QuerySnapshot result = await Firestore.instance
//        .collection('users')
//        .where('id', isEqualTo: document["id"])
//        .getDocuments();
//    final List<DocumentSnapshot> documents = result.documents;

      // Update data to server if new user
      await Firestore.instance
          .collection('users')
          .document(document["id"])
          .updateData({
        "warned": true,
        'warningMessage' : warningMsg,
      });

      textEditingController.clear();
  }

  Future<void> deleteUser(document) async {

    var documentReference = Firestore.instance
        .collection('deleteUser')
        .document("delete_")
    .collection("user")
        .document(DateTime.now().millisecondsSinceEpoch.toString());

    Firestore.instance.runTransaction((transaction) async {
      await transaction.set(
        documentReference,
        {
          'id': document["id"],
          'name': document['nickname']

        },
      );
    });
    Firestore.instance
        .collection('users')

        .document(document['id'])
        .delete();



  }



}
