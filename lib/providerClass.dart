import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Counter with ChangeNotifier {
  int _counter;

  Counter(this._counter);

  getCounter() => _counter;
  setCounter(int counter) => _counter = counter;

  void increment() {
    _counter++;
    notifyListeners();
  }

  void decrement() {
    _counter--;
    notifyListeners();
  }
}

class EmailPass with ChangeNotifier {
  String _email, _password, _id;
  FirebaseUser _user;

  bool _authenticate;

  EmailPass(this._authenticate);
  getEmail ()=> _email;
  getPass ()=> _password;
  getAuth ()=> _authenticate;
  getID ()=> _id;
  getUser () => _user;

  setEmail(String email) => _email =email;
  setPass(String password) => _password=password;

  void setAuth(authenticate){
    _authenticate = authenticate;

    notifyListeners();
  }

  void setCred(String email, String password){
    setEmail(email);
    setPass(password);
    notifyListeners();

  }


}