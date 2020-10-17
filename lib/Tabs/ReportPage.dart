import 'dart:io';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ultimax2/ReplyPage.dart';

import '../fullPhoto.dart';
import '../Model/providerClass.dart';

class Report extends StatelessWidget {
  final String peerId;
  final String peerAvatar;

  var primaryColor = Colors.blue;

  Report({Key key, @required this.peerId, @required this.peerAvatar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new ReportScreen(
        peerId: peerId,
        peerAvatar: peerAvatar,
      ),
    );
  }
}

class ReportScreen extends StatefulWidget {
  final String peerId;
  final String peerAvatar;

  ReportScreen({Key key, @required this.peerId, @required this.peerAvatar})
      : super(key: key);

  @override
  State createState() =>
      new ReportScreenState(peerId: peerId, peerAvatar: peerAvatar);
}

class ReportScreenState extends State<ReportScreen> {
  var greyColor2 = Colors.grey;

  Color themeColor = Colors.yellow;

  Color black = Colors.black;

  var imageURL;
  TextEditingController _editingController = new TextEditingController() ;


  ReportScreenState({Key key, @required this.peerId, @required this.peerAvatar});

  var primaryColor = Colors.white;

  String peerId;
  String peerAvatar;
  String id;
  bool openAdmin = false;

  var listMessage;
  String groupChatId;
  SharedPreferences prefs;

  File imageFile;
  bool isLoading;
  bool isShowSticker;
  String imageUrl;
  String SenderImage;
  bool admin;
  String userName;

  final TextEditingController textEditingController =
  new TextEditingController();
  final ScrollController listScrollController = new ScrollController();
  final FocusNode focusNode = new FocusNode();
  bool  attachmentAvail;


  @override
  void initState() {
    super.initState();
    focusNode.addListener(onFocusChange);

    groupChatId = '';

    isLoading = false;
    isShowSticker = false;
    imageUrl = '';
    admin = false;
    attachmentAvail = false;


    readLocal();
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide sticker when keyboard appear
      setState(() {
        isShowSticker = false;
      });
    }
  }

  readLocal() async {
    prefs = await SharedPreferences.getInstance();
    SenderImage = prefs.getString("photoUrl");
    userName = prefs.getString("nickname");
    admin = prefs.getBool("admin");

    id = prefs.getString('id') ?? '';
    if (id.hashCode <= peerId.hashCode) {
      groupChatId = '$id-$peerId';
    } else {
      groupChatId = '$peerId-$id';
    }

    Firestore.instance
        .collection('users')
        .document(id)
        .updateData({'chattingWith': peerId});

    setState(() {});
  }

  Future getImage() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    if (imageFile != null) {
      setState(() {
        isLoading = true;
        attachmentAvail = true;
      });
      // uploadFile();
    }
  }



  Future uploadFile(content) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;

    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      imageUrl = downloadUrl;

      if (content.trim() != '') {
        textEditingController.clear();

        var documentReference = Firestore.instance
            .collection('Notice')
            .document("Notice_")
            .collection("Ultimax")
            .document(DateTime.now().millisecondsSinceEpoch.toString());

        Firestore.instance.runTransaction((transaction) async {
          await transaction.set(
            documentReference,
            {
              'idFrom': prefs.getString("id") ,
              'idTo': "groupNotice",
              'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
              'content': content,
              'attachment': downloadUrl,
              'postToAlert': false
            },
          );
        });
        listScrollController.animateTo(0.0,
            duration: Duration(milliseconds: 300), curve: Curves.easeOut);
      } else {
        Fluttertoast.showToast(msg: 'Nothing to send');
      }

      setState(() {
        isLoading = false;
        //onSendMessage(imageUrl);
      });
    }, onError: (err) {
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: 'This file is not an image');
    });
  }
  void onSendMessage(String content) {
    // type: 0 = text, 1 = image, 2 = sticker

    if (attachmentAvail) {
      uploadFile(content);
    } else {
      if (content.trim() != '') {
        textEditingController.clear();

        var documentReference = Firestore.instance
            .collection('Notice')
            .document("Notice_")
            .collection("Ultimax")
            .document(DateTime.now().millisecondsSinceEpoch.toString());

        Firestore.instance.runTransaction((transaction) async {
          await transaction.set(
            documentReference,
            {
              'idFrom': prefs.getString("id"),
              'idTo': "groupNotice",
              'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
              'content': content,
              'attachment': imageURL != null ? imageURL : "no_image",
              'postToAlert': false
            },
          );
        });
        listScrollController.animateTo(0.0,
            duration: Duration(milliseconds: 300), curve: Curves.easeOut);

      } else {
        Fluttertoast.showToast(msg: 'Nothing to send');
      }
    }
  }


  Widget buildItem(int index, DocumentSnapshot document) {
    if (document['idFrom'] == "ultimaxAlertAdmin"){
      return Container();
    }

    if (document['idFrom'] == id && admin == false) {
      // Right (my message)
      return
        GestureDetector(
            child: Padding(
                padding: EdgeInsets.all(4.0),
                child: Container(


                  child: Column(
                    // Decides which type of post it is and shows accordingly
                    children: <Widget>[
                      Container(
                        child: Text("ALERT "+
                            DateFormat('dd/ MM/ yyyy [kk:mm]').format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    int.parse(document['timestamp']))),
                          style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        margin: EdgeInsets.only( top: 5.0),
                      ),
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
                            style: TextStyle(color: Colors.white, fontSize: 17),
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

                    ],
//              ), color: Colors.black87, elevation: 10, borderOnForeground: true,

                  ),
                  decoration: BoxDecoration(
//                    border: Border.all(color: Colors.blueGrey),
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: AssetImage("assets/icons/bg_chat.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
            )
        );
    } else if(admin == true ) {
      // if signed in as admin

      return
        GestureDetector(
          onTap: (){
            openDialog(document);
          },
            child: Padding(
                padding: EdgeInsets.all(4.0),
                child: Container(


                  child: Column(
                    // Decides which type of post it is and shows accordingly
                    children: <Widget>[
                      Container(
                        child: Text("ALERT "+
                            DateFormat('dd/ MM/ yyyy [kk:mm]').format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    int.parse(document['timestamp']))),
                          style: TextStyle(
                              color: Colors.blueGrey,
                              fontSize: 14.0,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                        margin: EdgeInsets.only( top: 5.0),
                      ),
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
                            style: TextStyle(color: Colors.white, fontSize: 17),
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

                    ],
//              ), color: Colors.black87, elevation: 10, borderOnForeground: true,

                  ),
                  decoration: BoxDecoration(
//                    border: Border.all(color: Colors.blueGrey),
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: AssetImage("assets/icons/bg_chat.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
            )
        );    }
  }

  bool isLastMessageLeft(int index) {
    if ((index > 0 &&
        listMessage != null &&
        listMessage[index - 1]['idFrom'] == id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  bool isLastMessageRight(int index) {
    if ((index > 0 &&
        listMessage != null &&
        listMessage[index - 1]['idFrom'] != id) ||
        index == 0) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> onBackPress() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      Firestore.instance
          .collection('users')
          .document(id)
          .updateData({'chattingWith': null});
      Navigator.pop(context);
    }

    return Future.value(false);
  }

  @override
  Widget build(BuildContext context) {


    return WillPopScope(
      child: Container(
          child: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  // List of messages
                  buildListMessage(),

                  // Sticker
//                  (isShowSticker ? buildSticker() : Container()),

                  // Input content
                  !admin ? buildInput(): Container(),
                ],
              ),

              // Loading
              buildLoading()
            ],
          ),
          decoration: BoxDecoration(

          )),
      onWillPop: onBackPress,
    );
  }


  Widget buildLoading() {
    return Positioned(
      child: isLoading
          ? Container(
        child: Center(
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(themeColor)),
        ),
        color: Colors.white.withOpacity(0.8),
      )
          : Container(),
    );
  }

  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          // Button send image
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 1.0),
              child: new IconButton(
                key: Key("attachment"),
                icon: new Icon(Icons.photo),
                onPressed: getImage,
                color: Colors.blue,
              ),
            ),
            color: Colors.white,
          ),

          // Edit text
          Flexible(
            child: Container(
              child: TextField(
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: null,
                style: TextStyle(color: Colors.black, fontSize: 15.0),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: greyColor2),
                ),
                focusNode: focusNode,
              ),
            ),
          ),

          // Button send message
          Material(

            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 8.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () => onSendMessage(textEditingController.text),
                color: Colors.blue,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: new BoxDecoration(
          border:
          new Border(top: new BorderSide(color: greyColor2, width: 0.5)),
          color: Colors.white),
    );
  }

  Widget buildListMessage() {
    return Flexible(
      child: groupChatId == ''
          ? Center(
          child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(themeColor)))
          : StreamBuilder(
        stream: Firestore.instance
            .collection('Notice')
            .document("Notice_")
            .collection("Ultimax")
        .where("postToAlert", isEqualTo: false)
            .orderBy('timestamp', descending: true)
            .limit(500)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: Container()
            );
          } else {
            listMessage = snapshot.data.documents;

            prefs.setInt("repRead", listMessage.length);
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

  Future<void> PostAlert(DocumentSnapshot doc) async {
    try {
      await Firestore.instance.collection('Notice').document("Notice_").collection("Ultimax").document(doc.documentID).updateData({
        'postToAlert': true,
        'content': _editingController.text
      });
    } catch (e) {
      print(e.toString());
    }
  }

  Future<Null> openDialog(DocumentSnapshot document) async {


    _editingController.text = document ["content"];
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
                        Icons.delete,
                        size: 30.0,
                        color: Colors.white,
                      ),
                      margin: EdgeInsets.only(bottom: 10.0),
                    ),
                    Text(
                      'Post To Alert',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Are you sure you want to Post Alert?',
                      style: TextStyle(color: Colors.white70, fontSize: 12.0),
                    ),
                  ],
                ),
              ),
              TextField(
                controller: _editingController,
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: null,
              ),
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
                  PostAlert(document);
                  Navigator.pop(context, 1);
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


}
