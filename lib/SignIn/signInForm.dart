import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ultimax2/AppBar/Settings.dart';
import 'package:ultimax2/SignIn/signInClass.dart';
import 'package:ultimax2/providerClass.dart';

import '../main.dart';

class SignInForm extends StatefulWidget {
  @override
  _SignInFormState createState() => _SignInFormState();
}

class Auth extends BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<FirebaseUser> signUp(
      String username, String email, String password) async {
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

class _SignInFormState extends State<SignInForm> {
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 14.0, color: Colors.white70,);
  final TextEditingController textEditingEmail = new TextEditingController();
  SharedPreferences prefs;

  final TextEditingController textEditingPassword = new TextEditingController();

  bool isLoading;

  bool isNew;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = false;
    isNew = false;
  }

  @override
  Widget build(BuildContext context) {
    final empass = Provider.of<EmailPass>(context);

    final emailField = TextField(

      controller: textEditingEmail,
      obscureText: false,
      style: style,
      key:Key("email"),
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Email", hintStyle: (TextStyle(color: Colors.white)),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0),
              )
      ),

    );
    final passwordField = TextField(
      key:Key("password"),

      controller: textEditingPassword,
      obscureText: true,
      style: style,

      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password",hintStyle: (TextStyle(color: Colors.white)),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final loginButon = Material(
      key: Key("login"),
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
            style:  TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white
                , fontFamily: "HANDGOTN")),
      ),
    );

    return SizedBox(
        height: 360,
        width: 280,
        child: Card(

          color: Colors.grey,
        elevation: 20,
        child: Padding(
          padding: EdgeInsets.all(8),
          child: Column(
            children: <Widget>[
          Image.asset(
                    'assets/icons/photo.png',
                    width: 50,
                    height: 50.0,
                    fit: BoxFit.fitWidth,
                  ),
              SizedBox(height: 15.0),

              Text("LOGIN",style:  TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                  , fontFamily: "HANDGOTN"),),
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
        )));
  }
  Future<void> getData(user) async {
    await Firestore.instance
        .collection("users")
        .where('id', isEqualTo: user.uid)

        .getDocuments()
        .then((QuerySnapshot snapshot) {
      snapshot.documents.forEach((f) {

        print(' this is the data ${f.data["isNew"]}');

        if (f.data["isNew"]){
          setState(() {
            isNew =f.data["isNew"];
          });
        }

      }

      );
    });
  }

  Future<void> passCredentialToParent(empass) async {
    prefs = await SharedPreferences.getInstance();

    try {
      FirebaseUser user =
          await Auth().signIn(textEditingEmail.text, textEditingPassword.text);
      print(
          await Auth().signIn(textEditingEmail.text, textEditingPassword.text));



      if (user != null) {

        getData(user);

        // Check is already sign up
        final QuerySnapshot result = await Firestore.instance
            .collection('users')
            .where('id', isEqualTo: user.uid)
            .getDocuments();
        final List<DocumentSnapshot> documents = result.documents;

        Firestore.instance.collection('users').document(user.uid).updateData({

          'isNew': false
        });

        if (documents.length == 0) {
          // Update data to server if new user
          Firestore.instance.collection('users').document(user.uid).setData({
            'nickname': user.displayName,
            'photoUrl': user.photoUrl,
            'id': user.uid,
            'createdAt': DateTime.now().millisecondsSinceEpoch.toString(),
            'chattingWith': null,
            'isNew': false
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


        if (isNew){
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Settings()));
        }
        else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MainScreen(currentUserId: user.uid)));
        }
      } else {
        Fluttertoast.showToast(msg: "Sign in fail");
        this.setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print(e);
      Fluttertoast.showToast(msg: "Contact Ultimax For Registration");
      this.setState(() {
        isLoading = false;
      });
    }
  }
}
