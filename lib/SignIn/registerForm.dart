import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ultimax2/SignIn/signInClass.dart';
import 'package:ultimax2/providerClass.dart';

import '../main.dart';

class RegisterForm extends StatefulWidget {
  @override
  _SignInFormState createState() => _SignInFormState();
}

class Auth extends BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<FirebaseUser> signUp(String username, String email,
      String password) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);

    FirebaseUser user = result.user;

    UserUpdateInfo userUpdateInfo = new UserUpdateInfo();
    userUpdateInfo.displayName = username;
    user.updateProfile(userUpdateInfo);
    try {
      await user.sendEmailVerification();
      return user;
    } catch (e) {
      print("An error occured while trying to send email  verification");
      print(e.message);
    }
  }

  @override
  Future<FirebaseUser> signIn(String email, String password) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    if (user.isEmailVerified) return user;
    return null;
  }

  @override
  Future<void> signOut() {
    // TODO: implement signOut
    return null;
  }
}

class _SignInFormState extends State<RegisterForm> {
  TextStyle style = TextStyle(
      fontWeight: FontWeight.bold, color: Colors.black, fontFamily: "HANDGOTN");

  final TextEditingController textEditingEmail = new TextEditingController();
  SharedPreferences prefs;

  final TextEditingController textEditingPassword = new TextEditingController();

  final TextEditingController textEditingUserName = new TextEditingController();

  bool isLoading;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    final emailField = TextField(
      controller: textEditingEmail,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Email",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final userNameField = TextField(
      controller: textEditingUserName,
      obscureText: false,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "User Name",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final passwordField = TextField(
      controller: textEditingPassword,
      obscureText: true,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery
            .of(context)
            .size
            .width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          passCredentialToParent();
        },
        child: Text("Add User", textAlign: TextAlign.center, style: style),
      ),
    );

    return SafeArea(child:Scaffold(
        body: Container(
            child: Stack(children: <Widget>[

             Align(
               alignment: Alignment.center,
               child:SizedBox(
                  height: 400,
                  width: 300,
                  child: Card(
                      elevation: 20,
                      color: Colors.white,
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          children: <Widget>[
                        Image.asset(
                        'assets/icons/photo.png',
                          width: 50,
                          height: 50.0,
                          fit: BoxFit.cover,
                        ),
                            SizedBox(height: 15.0),
                            emailField,
                            SizedBox(height: 15.0),
                            userNameField,
                            SizedBox(height: 15.0),
                            passwordField,
                            SizedBox(
                              height: 35.0,
                            ),
                            loginButon,
                            SizedBox(
                              height: 15.0,
                            ),
                          ],
                        ),
                      ))),),
              Positioned(
                child:isLoading
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
            ],),

            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/icons/UTXALERT.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ));
  }

  Future<void> passCredentialToParent() async {

    setState(() {
      isLoading = true;
    });
    prefs = await SharedPreferences.getInstance();
    try {
      FirebaseUser user = await Auth().signUp(textEditingUserName.text,
          textEditingEmail.text, textEditingPassword.text);
      print(user);


      if (user != null) {
        // Check is already sign up
        final QuerySnapshot result = await Firestore.instance
            .collection('users')
            .where('id', isEqualTo: user.uid)
            .getDocuments();
        final List<DocumentSnapshot> documents = result.documents;
        if (documents.length == 0) {
          // Update data to server if new user
          Firestore.instance
              .collection('users')
              .document(user.uid)
              .setData({
            'nickname': user.displayName,
            'photoUrl': null,
            'id': user.uid,
            'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
            'chattingWith': null,
            'isNew': true
          });

          Fluttertoast.showToast(msg: "Email Sent");
          this.setState(() {
            isLoading = false;
          });
        }
      }
        //else {
//
//        }
//        Fluttertoast.showToast(msg: "Sign in success");
//
//        this.setState(() {
//          isLoading = false;
//        });
//
//        user.getIdToken(refresh: true).then((idToken) =>
//        {prefs.setBool("admin", idToken.claims.containsKey("admin"))});
//
//        Navigator.push(
//            context,
//            MaterialPageRoute(
//                builder: (context) =>
//                    MainScreen(currentUserId: user.uid)));
//      } else {
//        Fluttertoast.showToast(msg: "Sign in fail");
//        this.setState(() {
//          isLoading = false;
//        });
//      }

    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Contact Ultimax For Registration");
      this.setState(() {
        isLoading = false;
      });
    }
  }
}
