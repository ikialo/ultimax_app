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
  bool _isLoad;
  String _title;

  bool _authenticate;

  EmailPass(this._isLoad);
  getEmail ()=> _email;
  getPass ()=> _password;
  getAuth ()=> _authenticate;
  getID ()=> _id;
  getUser () => _user;
  getTitle ()=> _title;

  setEmail(String email) => _email =email;
  setPass(String password) => _password=password;
  setTitle(String title) =>_title =title;

  void setAuth(authenticate){
    _authenticate = authenticate;

    notifyListeners();
  }

  getLoading() => _isLoad;
  void loading(load){
    _isLoad = load;

    notifyListeners();
  }

  void titleSet (String title){
    setTitle(title);
    notifyListeners();
  }

  void setCred(String email, String password){
    setEmail(email);
    setPass(password);
    notifyListeners();

  }


}

class ChangeTitle extends ChangeNotifier{

  String _title;


  ChangeTitle(this._title);
  getTitle () => _title;

  void setTitle(String title) {
    _title = title;
    notifyListeners();

  }

}