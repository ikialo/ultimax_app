import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import "package:flutter/material.dart";
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

class Dialog_content extends StatefulWidget {
  @override
  _Dialog_contentState createState() => _Dialog_contentState();
}

class _Dialog_contentState extends State<Dialog_content> {
  final TextEditingController textEditingController =
      new TextEditingController();
  File imageFile;
  bool isLoading;
  final FocusNode focusNode = new FocusNode();
  bool isShowSticker;
  bool admin;
  String imageURL;
  final ScrollController listScrollController = new ScrollController();

  var imageUrl;
  bool attachmentAvail;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    isLoading = false;
    attachmentAvail = false;
    focusNode.addListener(onFocusChange);

    isShowSticker = false;
    admin = false;
  }

  @override
  Widget build(BuildContext context) {
    return inputImg();
  }

  void onFocusChange() {
    if (focusNode.hasFocus) {
      // Hide sticker when keyboard appear
      setState(() {
        isShowSticker = false;
      });
    }
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

  Widget inputImg() {
    return SizedBox(
      child: Stack(
        children: <Widget>[

          imageFile != null
              ? Padding(
                  padding: EdgeInsets.all(1.0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      child: imageFile != null
                          ? Image.file(imageFile)
                          : Container(),
                      height: 280,
                      width: 280,
                    ),
                  ))
              : Container(),
          Align(
            child: SingleChildScrollView(child: buildInput()),
            alignment: Alignment.bottomCenter,
          ),
          imageFile != null
              ? Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    color: Colors.white,
                    onPressed: () {

                      setState(() {
                        imageFile = null;
                      });

                    },
                    icon: Icon(Icons.cancel),
                  ),
                )
              : Container(),
        ],
      ),
      height: 400,
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
                icon: new Icon(Icons.attach_file),
                onPressed: getImage,
                color: Colors.black,
              ),
            ),
            color: Colors.white,
          ),

          // Edit text
          Flexible(
            child: Container(
              height: 70,
              child: TextField(
                keyboardType: TextInputType.multiline,
                minLines: 1,
                maxLines: null,
                style: TextStyle(color: Colors.black, fontSize: 15.0),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type your message...',
                  hintStyle: TextStyle(color: Colors.grey),
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
                onPressed: () {
                  onSendMessage(textEditingController.text);
                  Navigator.pop(context);
                },
                color: Colors.black,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      decoration: new BoxDecoration(
          border:
              new Border(top: new BorderSide(color: Colors.grey, width: 0.5)),
          color: Colors.white),
    );
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
              'idFrom': "ultimaxAlertAdmin",
              'idTo': "groupNotice",
              'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
              'content': content,
              'attachment': imageURL != null ? imageURL : "no_image",
            },
          );
        });
        listScrollController.animateTo(0.0,
            duration: Duration(milliseconds: 300), curve: Curves.easeOut);

        Navigator.pop(context);
      } else {
        Fluttertoast.showToast(msg: 'Nothing to send');
      }
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
              'idFrom': "ultimaxAlertAdmin",
              'idTo': "groupNotice",
              'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
              'content': content,
              'attachment': downloadUrl,
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
}
