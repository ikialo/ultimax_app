import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settings extends StatefulWidget {
  const Settings({Key key}) : super(key: key);

  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<Settings> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _agreedToTOS = true;

  final TextEditingController textEditingController =
      new TextEditingController();

  SharedPreferences prefs;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  bool admin = false;

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Settings"),
        ),
        floatingActionButton: admin == true
            ? FloatingActionButton(
                onPressed: () {},
                backgroundColor: Colors.yellow,
              )
            : Container(),
        body: Center(
          child: Column(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.all(20),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueGrey)),
                    child: Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: TextField(
                        keyboardType: TextInputType.multiline,
                        minLines: 1,
                        maxLines: null,
                        style: TextStyle(color: Colors.black, fontSize: 15.0),
                        controller: textEditingController,
                        decoration: InputDecoration.collapsed(
                          hintText: 'Input New Profile Name',
                          hintStyle: TextStyle(color: Colors.blueGrey),
                        ),
//          focusNode: focusNode,
                      ),
                    ),
                  )),
              FlatButton(
                onPressed: () {
                  onUpdateProfile(
                      textEditingController.text, prefs.getString("id"));
                },
                color: Colors.black,
                child: Text(
                  "Submit",
                  style: TextStyle(color: Colors.white),
                ),
                splashColor: Colors.yellow,
              )
            ],
          ),
        ));
  }

  void onUpdateProfile(String content, uid) {
    // type: 0 = text, 1 = image, 2 = sticker

    UserUpdateInfo info = new UserUpdateInfo();
    info.displayName = content;
    if (content.trim() != '') {
      textEditingController.clear();

      Firestore.instance.collection('users').document(uid).updateData({
        'nickname': content,
      });

      prefs.setString('nickname', content);

      FirebaseUser fbu = FirebaseAuth.instance.currentUser() as FirebaseUser;

      fbu.updateProfile(info);
    }
  }
}
