import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ultimax2/TabParent.dart';
import 'package:ultimax2/Tabs/CallNumbers.dart';
import 'package:ultimax2/Tabs/Chat.dart';
import 'package:ultimax2/Tabs/Private_Message.dart';
import 'package:ultimax2/Tabs/Ultimax_Notificaiton.dart';
import 'package:ultimax2/providerClass.dart';

import 'AppBar/mainDrawer.dart';
import 'AppBar/tab_selection.dart';
import 'AppBar/Settings.dart';
import 'SignIn/UserSignIN.dart';

void main() => runApp(ChangeNotifierProvider<ChangeTitle> (

    child: MyApp(),
   create: (_) => ChangeTitle("Alert"),));





class MainScreen extends StatefulWidget {
  final String currentUserId;

  MainScreen({Key key, @required this.currentUserId}) : super(key: key);

  @override
  State createState() => MainScreenState(currentUserId: currentUserId);
}

class MainScreenState extends State<MainScreen> {
  MainScreenState({Key key, @required this.currentUserId});

  final String currentUserId;
  final FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  new FlutterLocalNotificationsPlugin();
  final GoogleSignIn googleSignIn = GoogleSignIn();

  SharedPreferences prefs;
  bool admin;

  Color black = Colors.black;

  String photo = null;

  bool isLoading = false;
  String iconbtnPath;

  double imageWidth, imageHeight;

//  List<Choice> choices = const <Choice>[
//    const Choice(title: 'Settings', icon: Icons.settings),
//    const Choice(title: 'Log out', icon: Icons.exit_to_app),
//  ];

  @override
  void initState() {
    super.initState();
    admin = false;
    registerNotification();
    configLocalNotification();

    getURLPHOTO();
    setPrefs();
    iconbtnPath ='assets/icons/photo.png';
    iconbtnPath ='assets/icons/press_icon_btn.png';
    iconbtnPath ='assets/icons/photo.png';

    setState(() {
      imageHeight =200;
      imageWidth = 200;
    });


  }

  Future<void> registerNotification() async {
    prefs = await SharedPreferences.getInstance();

    firebaseMessaging.subscribeToTopic("alert").then((res) {
      print("is subscribed");
    }).catchError((onError) {
      print("error");
    });

    firebaseMessaging.subscribeToTopic("notice").then((res) {
      print("is subscribed");
    }).catchError((onError) {
      print("error");
    });

    firebaseMessaging.requestNotificationPermissions();

    firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print('onMessage: $message');
      showNotification(message['notification']);
      return;
    }, onResume: (Map<String, dynamic> message) {
      print('onResume: $message');
      return;
    }, onLaunch: (Map<String, dynamic> message) {
      print('onLaunch: $message');
      return;
    });

    firebaseMessaging.getToken().then((token) {
      print('token: $token');
      Firestore.instance
          .collection('users')
          .document(currentUserId)
          .updateData({'pushToken': token});
    }).catchError((err) {
      Fluttertoast.showToast(msg: err.message.toString());
    });
  }

  void setPrefs() async {
    prefs = await SharedPreferences.getInstance();

    setState(() {
      admin = prefs.getBool("admin");
    });
  }

  void adminSetFalse() async {
    prefs = await SharedPreferences.getInstance();

    prefs.setBool("admin", false);
    prefs.setBool("signIn", false);
  }

  void configLocalNotification() {
    var initializationSettingsAndroid =
    new AndroidInitializationSettings('app_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

//  void onItemMenuPress(Choice choice) {
//    if (choice.title == 'Log out') {
//      handleSignOut();
//    } else {
//      Navigator.push(
//          context, MaterialPageRoute(builder: (context) => Settings()));
//    }
//  }

  void CreateMessageBoard() {
    String groupChatId = "messbo";
    var documentReference = Firestore.instance
        .collection('MessageBoard')
        .document(groupChatId)
        .collection(groupChatId)
        .document(DateTime
        .now()
        .millisecondsSinceEpoch
        .toString());
  }

  void showNotification(message) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'synarcsystems.com.ultimax2',
      'Ultimax',
      'your channel description',
      playSound: true,
      enableVibration: true,
      importance: Importance.Max,
      priority: Priority.High,
      channelShowBadge: true,
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, message['title'].toString(),
        message['body'].toString(), platformChannelSpecifics,
        payload: 'Default_Sound');
  }

  Future<bool> onBackPress() {
    openDialog();
    return Future.value(false);
  }

  Future<Null> openDialog() async {
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
                        Icons.exit_to_app,
                        size: 30.0,
                        color: Colors.white,
                      ),
                      margin: EdgeInsets.only(bottom: 10.0),
                    ),
                    Text(
                      'Exit app',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Are you sure to exit app?',
                      style: TextStyle(color: Colors.white70, fontSize: 14.0),
                    ),
                  ],
                ),
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
        exit(0);
        break;
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

  Future<void> getURLPHOTO() async {
    await Firestore.instance.collection("users").document(currentUserId)
        .get()
        .then((url) {
      setState(() {
        photo = url["photoUrl"];
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    ChangeTitle ct = Provider.of<ChangeTitle>(context);
    return Scaffold(
        backgroundColor: Colors.black12,

        appBar: AppBar(),
//      appBar: AppBar(
//        title: Text(
//          'ULTIMAX ALERT',
//          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
//        ),
//        centerTitle: true,
//        actions: <Widget>[
//          PopupMenuButton<Choice>(
//            onSelected: onItemMenuPress,
//            itemBuilder: (BuildContext context) {
//              return choices.map((Choice choice) {
//                return PopupMenuItem<Choice>(
//                    value: choice,
//                    child: Row(
//                      children: <Widget>[
//                        Icon(
//                          Icons.menu,
//                          color: black,
//                        ),
//                        Container(
//                          width: 10.0,
//                        ),
//                        Text(
//                          choice.title,
//                          style: TextStyle(color: black),
//                        ),
//                      ],
//                    ));
//              }).toList();
//            },
//          ),
//        ],
//      ),

        drawer: Drawer(
            child: DrawMain(currentUserId: currentUserId,)
        ),
        body: ChangeNotifierProvider<ChangeTitle>(child:
        
        SafeArea(
          child: WillPopScope(
            child: Container(
                child: Stack(
                  children: <Widget>[



                    Center(
                      child: new Container(

                        child: new Material(
                          child: GestureDetector(
                              child: Padding(
                                padding: EdgeInsets.only(top: 10.0),
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Hero(
                                    tag: "ultimax+logo",
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.circular(50.0),
                                        child: Image.asset(iconbtnPath
                                          ,
                                          width: imageWidth,
                                          height:imageHeight,
                                          fit: BoxFit.cover,
                                        )),
                                  ),
                                ),
                              ),

                              key: Key("openTabOptions"),
                              onTapUp: (tap){
                                setState(() {
                                  iconbtnPath ='assets/icons/photo.png';
                                  imageWidth = 200;
                                  imageHeight =200;
                                });
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            TabSelection(
                                              peerId: "messageboardid",
                                              peerAvatar: 'photoUrl',
                                            )));
                              },

                              onTapDown: (tap) {

                                setState(() {
                                  iconbtnPath ='assets/icons/press_icon_btn.png';

                                  imageWidth = 350;
                                  imageHeight =350;
                                });

                              }
                          ),
                          color: Colors.transparent,
                        ),
                    decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.0),),

                      ),
                    ),


                    Positioned(
                      child: isLoading
                          ? Container(
                        child: Center(
                          child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.yellow)),
                        ),
                        color: Colors.white.withOpacity(0.8),
                      )
                          : Container(),
                    ),
                    Positioned(
                      right: 45.0,
                      bottom: 2.0,
                      child: Opacity(child: Text(
                        "Developed by Synarc Systems",
                        style: TextStyle(color: Colors.white, fontSize: 10.0),
                      ), opacity: 0.7,),),
                    Positioned(
                        right: 10.0,
                        bottom: 2.0,
                        child: Hero(
                            tag: "DemoTag",
                            child: Opacity(child: ClipRRect(
                                borderRadius: BorderRadius.circular(50.0),
                                child: Image.asset(
                                  'assets/icons/SYNARC.jpg',
                                  width: 18.0,
                                  height: 18.0,
                                  fit: BoxFit.cover,
                                )), opacity: 0.7,)
                        )),
                  ],
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/icons/UTXALERT.jpg"),
                    fit: BoxFit.cover,
                  ),
                )
            ),
            onWillPop: onBackPress,
          ),
        ),

          create: (BuildContext context) {ChangeTitle("Alert");},),


    );
  }


//
}




