import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ultimax2/SignIn/signInClass.dart';
import 'package:ultimax2/providerClass.dart';

import '../main.dart';

class SignInForm extends StatefulWidget {
  @override
  _SignInFormState createState() => _SignInFormState();
}


class Auth extends BaseAuth{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<String> signUp(String username, String email, String password) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);

    FirebaseUser user = result.user;

    UserUpdateInfo userUpdateInfo = new UserUpdateInfo();
    userUpdateInfo.displayName = username;
    user.updateProfile(userUpdateInfo);
    try {
      await user.sendEmailVerification();
      return user.uid;
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


class _SignInFormState extends State<SignInForm> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 14.0);
  final TextEditingController textEditingEmail =
  new TextEditingController();
  SharedPreferences prefs;

  final TextEditingController textEditingPassword =
  new TextEditingController();

  bool isLoading;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = false;


  }


  @override
  Widget build(BuildContext context) {

    final empass = Provider.of<EmailPass>(context);

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
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          passCredentialToParent(empass);
        },
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
        body: SingleChildScrollView(
            child: Center(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(36.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 300.0,
                child: ClipRRect(

                  child: Image.asset(
                  "assets/icons/photo.jpg",
                  fit: BoxFit.contain,
                  height: 70,
                  width: 70,
                ),borderRadius: BorderRadius.circular(50),
              ),),
              Card(

                elevation: 20,

                  color: Colors.white,

                  child: Padding(
                padding: EdgeInsets.all(8),

                child: Column(
                  children: <Widget>[
                    SizedBox(height: 15.0),
                    emailField,
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
              ))
            ],
          ),
        ),
      ),
    )));
  }

  Future<void> passCredentialToParent(empass) async {

    empass.setCred(textEditingEmail.text, textEditingPassword.text);

    prefs = await SharedPreferences.getInstance();
    try{

      FirebaseUser user = await Auth().signIn(textEditingEmail.text, textEditingPassword.text);
      print (await Auth().signIn(textEditingEmail.text, textEditingPassword.text));



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
              'photoUrl': user.photoUrl,
              'id': user.uid,
              'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
              'chattingWith': null
            });

            // Write data to local

            await prefs.setString('id', user.uid);
            await prefs.setString('nickname', user.displayName);
            await prefs.setString('photoUrl', user.photoUrl);
          } else {
            // Write data to local
            await prefs.setString('id', documents[0]['id']);
            await prefs.setString('nickname', documents[0]['nickname']);
            await prefs.setString('photoUrl', documents[0]['photoUrl']);
            await prefs.setString('aboutMe', documents[0]['aboutMe']);
          }
          Fluttertoast.showToast(msg: "Sign in success");

          empass.setAuth(true);
          this.setState(() {
            isLoading = false;
          });

          user.getIdToken(refresh: true).then((idToken) =>
          {prefs.setBool("admin", idToken.claims.containsKey("admin"))});

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      MainScreen(currentUserId: user.uid)));
        } else {
          Fluttertoast.showToast(msg: "Sign in fail");
          this.setState(() {
            isLoading = false;
          });
        }

    }
    catch(e){
      print(e);
    }
  }
}
