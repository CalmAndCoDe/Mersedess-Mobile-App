import 'dart:async';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

var _userCredentials;

class SignUpUser {
  bool signUpSuccess = false;
  String signUpErrors = '';
  var loading = ValueNotifier(false);

  final StreamController signUpState = StreamController.broadcast();
  StreamSink get signUpIn => signUpState.sink;
  Stream get signUpStream => signUpState.stream;

  final StreamController signUpEvents = StreamController();
  Sink get signUpEvent => signUpEvents.sink;

  dispose() {
    signUpEvents.close();
  }

  SignUpUser() {
    signUpEvents.stream.listen(_mapEventToState);
  }

  static final _getInstance = SignUpUser();
  static PageController page;

  get pageGetter => page;

  set pageSetter(PageController param) {
    page = param;
  }

  factory SignUpUser.instance() {
    return _getInstance;
  }

  _mapEventToState(event) async {
    if (event is CreateUser) {
      loading.value = true;
      var res = await CreateUser(event.credentials).create();
      loading.value = false;
      if (res == 'validation error' || res == 'Empty Fields') {
        signUpSuccess = false;
        signUpErrors = 'Not Valid or Empty ';
      } else if (res == 'change username') {
        signUpSuccess = false;
        signUpErrors = 'Change Username or Email';
      } else {
        page.nextPage(
            duration: Duration(milliseconds: 500), curve: Curves.easeInCirc);
      }
    } else {
      signUpSuccess = false;
      signUpState.add(signUpSuccess);
    }
    signUpState.add(signUpSuccess);
  }
}

class CreateUser {
  final credentials;

  CreateUser(this.credentials);

  create() async {
    if (credentials['username'] != null &&
        credentials['password'] != null &&
        credentials['email'] != null) {
      _userCredentials = {
        'username': credentials['username'],
        'password': credentials['password']
      };
      FlutterSecureStorage()
          .write(key: 'user', value: _userCredentials['username']);
      FlutterSecureStorage()
          .write(key: 'key', value: _userCredentials['password']);
      var storage = await SharedPreferences.getInstance();
      storage.setInt('steps', 1);
      var res = await post('https://mersedess-beta.herokuapp.com/api/signup', body: {
        'username': credentials['username'],
        'email': credentials['email'],
        'password': credentials['password']
      }).catchError((err) => err);
      print(res);
      // return res.body;
    } else {
      return 'Empty Fields';
    }
  }
}

class Email {
  var loading = ValueNotifier(false);
  var errors = ValueNotifier('');

  Email();

  static final _getInstance = Email();
  factory Email.instance() {
    return _getInstance;
  }

  emailConfirm() async {
    loading.value = true;
    String _username;
    String _password;
    try {
      _username = _userCredentials['username'];
      _password = _userCredentials['password'];
    } catch (e) {
      _username = await FlutterSecureStorage().read(key: 'user');
      _password = await FlutterSecureStorage().read(key: 'key');
    }

    var res = await post('https://mersedess-beta.herokuapp.com/api/login',body: {
      'username' : _username,
      'password' : _password
    });
    loading.value = false;
    return res.body;
  }
}
