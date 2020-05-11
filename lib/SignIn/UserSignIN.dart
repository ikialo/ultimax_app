import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ultimax2/SignIn/signInForm.dart';

import '../CustomCurve.dart';
import '../main.dart';
import '../providerClass.dart';

class MyApp extends StatelessWidget {
  Color black = Colors.black;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Chat Demo',
        theme: ThemeData(
          primaryColor: black,
        ),
        home: ChangeNotifierProvider<EmailPass>(
          builder: (_) => EmailPass(false),
          child: LoginScreen(title: 'CHAT DEMO'),
        ));
  }
}

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  LoginScreenState createState() => LoginScreenState();
}

@override
Future<void> signOut() async {
  await FirebaseAuth.instance.signOut();
  return null;
}

class LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  SharedPreferences prefs;

  bool _log = false;

  bool isLoading = false;
  bool isLoggedIn = false;
  FirebaseUser currentUser;

  @override
  void initState() {
    super.initState();
    isSignedIn();
  }

  void isSignedIn() async {
    this.setState(() {
      isLoading = true;
    });

    prefs = await SharedPreferences.getInstance();
    print(await FirebaseAuth.instance.currentUser());
    if (await FirebaseAuth.instance.currentUser() != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                MainScreen(currentUserId: prefs.getString('id'))),
      );
    }
    this.setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
//    final empass = Provider.of<EmailPass>(context);

    return Scaffold(

//      floatingActionButton: FloatingActionButton(onPressed: handleReg,),

        body: Container(
      child: Stack(
        children: <Widget>[
          SafeArea(
            child: Align(
              alignment: Alignment.center,
              child: Opacity(
                child: SignInForm(), opacity: .95,
              ),
            ),
          ),

//              Align(
//                  alignment: Alignment.topCenter,
//                  child: Image.asset(
//                    'assets/icons/topdec.png',
//                    width: 700,
//                    height: 150.0,
//                    fit: BoxFit.fitWidth,
//                  )),

//              Positioned(
//                top: 70,
//                left: 50,
//                child: Text(
//                  "Login",
//                  style: TextStyle(
//                    color: Colors.white,
//                    fontSize: 22,
//                  ),
//                ),
//              ),

              Positioned(
                  right: 45.0,
                  bottom: 12.0,
                  child: Text(
                    "Developed by Synarc Systems",
                    style: TextStyle(color: Colors.white70, fontSize: 10.0),
                  )),
              Positioned(
                  right: 10.0,
                  bottom: 12.0,
                  child: Hero(
                    tag: "DemoTag",
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(50.0),
                        child: Image.asset(
                          'assets/icons/SYNARC.jpg',
                          width: 18.0,
                          height: 18.0,
                          fit: BoxFit.cover,
                        )),
                  )),

          // Loading
          Positioned(
            child: isLoading
                ? Container(
                    child: Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    ),
                    color: Colors.white.withOpacity(0.8),
                  )
                : Container(),
          ),
        ],
      ),
    decoration: BoxDecoration(
        image: DecorationImage(
        image: AssetImage("assets/icons/UTXALERT.jpg"),
      fit: BoxFit.cover,
    ),
    )
        )
    );
  }
}
