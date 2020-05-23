import 'dart:io';

import 'package:circular_profile_avatar/circular_profile_avatar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ultimax2/SignIn/UserSignIN.dart';
import 'package:ultimax2/SignIn/registerForm.dart';
import 'package:ultimax2/main.dart';

class Settings extends StatefulWidget {
  const Settings({Key key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<Settings> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _agreedToTOS = true;
  File imageFile;

  final TextEditingController textEditingController =
      new TextEditingController();

  final TextEditingController textEditingPassword = new TextEditingController();
  final TextEditingController textEditingPasswordConfirm =
      new TextEditingController();

  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  SharedPreferences prefs;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  bool admin = false;
  bool isLoading;

  bool attachmentAvail;

  String imageUrl;

  void setPrefs() async {
    prefs = await SharedPreferences.getInstance();

    setState(() {
      admin = prefs.getBool("admin");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setPrefs();
    isLoading = false;
    attachmentAvail = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: () {


                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              MainScreen(currentUserId: prefs.get("id"))));
                },
                  )
            ],
            leading: Container(),
            title: Center(
              child: Text(
                "Settings",
                style: TextStyle(fontFamily: "HANDGOTN"),
              ),
            )),
        body: SingleChildScrollView(
            child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 35,
              ),
              Text(
                "Profile Picture",
                style: TextStyle(fontFamily: "HANDGOTN"),
              ),
              SizedBox(
                height: 15,
              ),
              InkWell(
                child: CircularProfileAvatar(
                  '',
                  child: imageFile != null
                      ? Image.file(imageFile)
                      : Icon(Icons.account_circle),
                  borderColor: Colors.black,
                  borderWidth: 2,
                  elevation: 2,
                  radius: 50,
                ),
                onTap: getImage,
                splashColor: Colors.black,
              ),
              SizedBox(
                height: 15,
              ),

              Form(
                  key: _form,
                  child: Column(children: <Widget>[
                    Text(
                      "User Name",
                      style: TextStyle(fontFamily: "HANDGOTN"),
                    ),
                    Padding(
                        padding: EdgeInsets.all(20),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.blueGrey)),
                          child: Padding(
                            padding: EdgeInsets.only(left: 20.0),
                            child: TextFormField(
                              keyboardType: TextInputType.multiline,
                              minLines: 1,
                              maxLines: null,
                              validator: (val) {
                                if (val.isEmpty) return 'Empty';
                                return null;
                              },

                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.0,
                                  fontFamily: "HANDGOTN"),
                              controller: textEditingController,
                              decoration: InputDecoration.collapsed(
                                hintText: 'Input New Profile Name',
                                hintStyle: TextStyle(
                                    color: Colors.blueGrey, fontFamily: "HANDGOTN"),
                              ),
//          focusNode: focusNode,
                            ),
                          ),
                        )),
                    Text(
                      "Change Password",
                      style: TextStyle(fontFamily: "HANDGOTN"),
                    ),

                    Padding(
                        padding: EdgeInsets.all(20),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.blueGrey)),
                          child: Padding(
                            padding: EdgeInsets.only(left: 20.0),
                            child: TextFormField(
                              validator: (val) {
                                if (val.length < 6) return "password must be 6 characters long";

                                if (val.isEmpty) return 'Empty';
                                return null;
                              },

                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.0,
                                  fontFamily: "HANDGOTN"),
                              controller: textEditingPassword,
                              decoration: InputDecoration.collapsed(
                                hintText: 'New Password',
                                hintStyle: TextStyle(
                                    color: Colors.blueGrey,
                                    fontFamily: "HANDGOTN"),
                              ),
//          focusNode: focusNode,
                            ),
                          ),
                        )),
                    Padding(
                        padding: EdgeInsets.all(20),
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.blueGrey)),
                          child: Padding(
                            padding: EdgeInsets.only(left: 20.0),
                            child: TextFormField(
                              validator: (val) {
                                if (val.isEmpty) return 'Empty';
                                if (val != textEditingPassword.text)
                                  return 'Not Match';
                                return null;
                              },

                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 15.0,
                                  fontFamily: "HANDGOTN"),
                              controller: textEditingPasswordConfirm,
                              decoration: InputDecoration.collapsed(
                                hintText: 'Confirm Password',
                                hintStyle: TextStyle(
                                    color: Colors.blueGrey,
                                    fontFamily: "HANDGOTN"),
                              ),
//          focusNode: focusNode,
                            ),
                          ),
                        )),
                  ])),
              FlatButton(
                onPressed: () {
                  if (_form.currentState.validate()) {
                    onUpdateProfile(
                        textEditingController.text, prefs.getString("id"));
                  }
                },
                color: Colors.black,
                child: Text(
                  "Submit",
                  style: TextStyle(color: Colors.white, fontFamily: "HANDGOTN"),
                ),
                splashColor: Colors.yellow,
              ),
            ],
          ),
        )));
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

  void checkValid() {
    if (_form.currentState.validate()) {
      print("Validated");
    }
  }
  Future<Null> handleSignOut() async {
    this.setState(() {
      isLoading = true;
    });

    adminSetFalse();
    await FirebaseAuth.instance.signOut();

    this.setState(() {
      isLoading = false;
    });

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => MyApp()),
            (Route<dynamic> route) => false);
  }

  Future<void> onUpdateProfile(String content, uid) async {
    // type: 0 = text, 1 = image, 2 = sticker

    await uploadFile();
    UserUpdateInfo info = new UserUpdateInfo();

//    await FirebaseAuth.instance.currentUser().then((onValue){
//
//      onValue.updatePassword(textEditingPasswordConfirm.text);
//    });

    if (content.trim() != '') {
      info.displayName = content;
      info.photoUrl = imageUrl;





      await Firestore.instance.collection('users').document(uid).updateData({
        'nickname': content,
        'photoUrl': imageUrl
      });

      prefs.setString('nickname', content);
      prefs.setString("photoUrl", imageUrl);

      FirebaseUser fbu = await FirebaseAuth.instance.currentUser();

      await fbu.updateProfile(info);
      await fbu.updatePassword(textEditingPassword.text);

      textEditingController.clear();
      textEditingPassword.clear();
      textEditingPasswordConfirm.clear();

      await handleSignOut();

    }

  }

  void adminSetFalse() async {
    prefs = await SharedPreferences.getInstance();

    prefs.setBool("admin", false);
    prefs.setBool("signIn", false);
  }
  Future uploadFile() async {
    setState(() {
      isLoading = true;
      //onSendMessage(imageUrl);
    });

    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference reference = FirebaseStorage.instance.ref().child(fileName);
    StorageUploadTask uploadTask = reference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await uploadTask.onComplete;

    await storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl) {
      imageUrl = downloadUrl;




//        textEditingController.clear();
//
//        var documentReference = Firestore.instance
//            .collection('users')
//            .document(prefs.get("id"))
//            .collection("Ultimax")
//            .document(DateTime.now().millisecondsSinceEpoch.toString());
//
//        Firestore.instance.runTransaction((transaction) async {
//          await transaction.set(
//            documentReference,
//            {
//              'idFrom': "ultimaxAlertAdmin",
//              'idTo': "groupNotice",
//              'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
//              'content': content,
//              'attachment': downloadUrl,
//            },
//          );
//        });



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
