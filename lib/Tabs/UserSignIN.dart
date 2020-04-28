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
          builder: (_) => EmailPass( false),
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
  String testuser;
  EmailPass _emailPass;

  @override
  void initState() {
    super.initState();
    isSignedIn();
    testuser = "try";
  }

  void isSignedIn() async {

    this.setState(() {
      isLoading = true;
    });

    prefs = await SharedPreferences.getInstance();
    print(await FirebaseAuth.instance.currentUser());


    if (await FirebaseAuth.instance.currentUser() !=null) {
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

//  Future<Null> handleReg() async {
//    print(await Auth().signUp("Kax", "isaacsilas05@gmail.com", "password"));
//  }
//
//  Future<Null> handleSign() async {
//    String username = await Auth().signIn("isaacsilas05@gmail.com", "password");
//    setState(() {
//      testuser = username;
//    });
//    print(username);
//  }

  Future<Null> handleSignIn() async {
    prefs = await SharedPreferences.getInstance();

    this.setState(() {
      isLoading = true;
    });

//    GoogleSignInAccount googleUser = await googleSignIn.signIn();
//    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//
//    final AuthCredential credential = GoogleAuthProvider.getCredential(
//      accessToken: googleAuth.accessToken,
//      idToken: googleAuth.idToken,
//    );
//
//    FirebaseUser firebaseUser =
//        (await firebaseAuth.signInWithCredential(credential)).user;

    FirebaseUser firebaseUser = _emailPass.getUser();

    if (firebaseUser != null) {
      // Check is already sign up
      final QuerySnapshot result = await Firestore.instance
          .collection('users')
          .where('id', isEqualTo: firebaseUser.uid)
          .getDocuments();
      final List<DocumentSnapshot> documents = result.documents;
      if (documents.length == 0) {
        // Update data to server if new user
        Firestore.instance
            .collection('users')
            .document(firebaseUser.uid)
            .setData({
          'nickname': firebaseUser.displayName,
          'photoUrl': firebaseUser.photoUrl,
          'id': firebaseUser.uid,
          'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
          'chattingWith': null
        });

        // Write data to local
        currentUser = firebaseUser;
        await prefs.setString('id', currentUser.uid);
        await prefs.setString('nickname', currentUser.displayName);
        await prefs.setString('photoUrl', currentUser.photoUrl);
      } else {
        // Write data to local
        await prefs.setString('id', documents[0]['id']);
        await prefs.setString('nickname', documents[0]['nickname']);
        await prefs.setString('photoUrl', documents[0]['photoUrl']);
        await prefs.setString('aboutMe', documents[0]['aboutMe']);
      }
      Fluttertoast.showToast(msg: "Sign in success");
      this.setState(() {
        isLoading = false;
      });

      firebaseUser.getIdToken(refresh: true).then((idToken) =>
          {prefs.setBool("admin", idToken.claims.containsKey("admin"))});
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  MainScreen(currentUserId: firebaseUser.uid)));
    } else {
      Fluttertoast.showToast(msg: "Sign in fail");
      this.setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    final empass = Provider.of<EmailPass>(context);




    return Scaffold(

//      floatingActionButton: FloatingActionButton(onPressed: handleReg,),
        backgroundColor: Colors.black12,
        body: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: SignInForm(),
            ),
            Align(
                alignment: Alignment.topCenter,
                child: Image.asset(
                  'assets/icons/topdec.png',
                  width: 700,
                  height: 150.0,
                  fit: BoxFit.fitWidth,
                )),

            Positioned(
              top: 70,
              left: 50,
              child: Text(
                empass.getAuth().toString()
                ,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                ),
              ),
            ),

            Positioned(
                right: 45.0,
                bottom: 12.0,
                child: Text(
                  "Developed by Synarc Systems",
                  style: TextStyle(color: Colors.blueGrey, fontSize: 10.0),
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
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                      ),
                      color: Colors.white.withOpacity(0.8),
                    )
                  : Container(),
            ),
          ],
        ));
  }
}
