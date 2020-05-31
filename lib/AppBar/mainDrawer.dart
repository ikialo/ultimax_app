import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ultimax2/AppBar/adminPMsg.dart';
import 'package:ultimax2/SignIn/registerForm.dart';
import 'package:ultimax2/SignIn/UserSignIN.dart';
import 'package:ultimax2/AppBar/listusers.dart';

import 'Settings.dart';

class DrawMain extends StatefulWidget {

  final String currentUserId;

  DrawMain({Key key, @required this.currentUserId}) : super(key: key);
  @override
  _DrawMainState createState() => _DrawMainState(currentUserId: currentUserId);
}

class _DrawMainState extends State<DrawMain> {

  _DrawMainState({Key key, @required this.currentUserId});

  String photo;
  bool isLoading = false;
  final String currentUserId;
  SharedPreferences prefs;
  bool admin;
  String name;




  Future<void> getURLPHOTO () async {
    await Firestore.instance.collection("users").document(currentUserId).get().then((url){

      setState(() {
        photo =url["photoUrl"];


      });
    });
  }

  void setPrefs() async {
    prefs = await SharedPreferences.getInstance();

    setState(() {
      admin = prefs.getBool("admin");
      name = prefs.getString("nickname");
    });
  }

  void adminSetFalse() async {
    prefs = await SharedPreferences.getInstance();

    prefs.setBool("admin", false);
    prefs.setBool("signIn", false);
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

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getURLPHOTO();
    setPrefs();
  }

  @override
  Widget build(BuildContext context) {

    final style =  TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.black
        , fontFamily: "HANDGOTN");
    return  ListView(
      children: <Widget>[
        UserAccountsDrawerHeader(
          accountName: Text(name != null? name: "No Name", style:  TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white
              , fontFamily: "HANDGOTN"),),
//                accountEmail: Text("ashishrawat2911@gmail.com"),
          currentAccountPicture: CircleAvatar(
            backgroundColor:
            Theme.of(context).platform == TargetPlatform.iOS
                ? Colors.blue
                : Colors.white,
            child:  photo != null?CachedNetworkImage(
              placeholder: (context, url) => Container(
                child: CircularProgressIndicator(
                  strokeWidth: 1.0,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
                ),
                width: 35.0,
                height: 35.0,
                padding: EdgeInsets.all(10.0),
              ),
              imageUrl:photo ,
              width: 35.0,
              height: 35.0,
              fit: BoxFit.cover,
            ): Image.asset("assets/icons/photo.png"),
          ),
        ),

        ListTile(
          title: Text("Settings",style: style,),
          trailing: Icon(Icons.settings),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => Settings()));
          },
        ),

        !admin ?Container(): ListTile(
          title: Text("Add User",style: style,),
          trailing: Icon(Icons.group_add),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => RegisterForm()));


          },
        ),
        !admin ?Container(): ListTile(
          title: Text("List Of Users",style: style,),
          trailing: Icon(Icons.group),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ListUsers()));


          },
        ),ListTile(
          title: Text("Message From Admin",style: style,),
          trailing: Icon(Icons.message),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => MessageFromAdmin(currentUserId: currentUserId,)));


          },
        ),



        ListTile(
          title: Text("Log out",style: style,),
          trailing: Icon(Icons.exit_to_app),
          onTap: handleSignOut,
        ),
      ],
    );
  }
}
