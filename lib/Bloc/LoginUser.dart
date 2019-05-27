import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum Done {UserCreate}
enum Error{AuthenticationError}

class LoginUser {
  bool isUserLoggedIn = false;
  var loginErrors = '';
  var loading = ValueNotifier(0);

  final StreamController loginState = StreamController.broadcast();
  StreamSink get loginIn => loginState.sink;
  Stream get loginStream => loginState.stream;

  final StreamController loginEvents = StreamController();
  Sink get loginEvent => loginEvents.sink;

  LoginUser() {
    loginEvents.stream.listen(_mapEventToState);
  }

  dispose() {
    loginEvents.close();
  }

  static final getInstance = LoginUser();

  factory LoginUser.instance() {
    return getInstance;
  }

  _mapEventToState(event) async {
    if (event is AutheticateUser) {
      loading.value = 1;
      var res = await AutheticateUser(
              credentials: event.credentials,
              shouldSaveToken: event.shouldSaveToken)
          .loginUser();
      loading.value = 0;
      if (res == 'login failed') {
        isUserLoggedIn = false;
        loginErrors = 'Username or password is wrong';
      } else if (res == 'password wrong') {
        isUserLoggedIn = false;
        loginErrors = 'Password is Wrong';
      } else if (res == 'Not Valid' || res == 'not valid') {
        isUserLoggedIn = false;
        loginErrors = "Empty Fields";
      } else {
        isUserLoggedIn = true;
        if (event.shouldSaveToken) {
          FlutterSecureStorage().write(key: 'login', value: 'true');
          var token = jsonDecode(res);
          FlutterSecureStorage().write(
            key: 'access_token',
            value: token['token']
          );
        }
      }
    } else if(event is Done){
      print(event);
      isUserLoggedIn = true;
    }else if(event is Error) {
      FlutterSecureStorage().deleteAll();
      isUserLoggedIn = false;
    }
    loginState.add(isUserLoggedIn);
  }
}

class AutheticateUser {
  final credentials;
  final bool shouldSaveToken;

  AutheticateUser({@required this.credentials, this.shouldSaveToken = false})
      : assert(credentials != null);

  loginUser() async {
    if (credentials['username'] != null && credentials['password'] != null) {
      var res = await post('https://mersedess-beta.herokuapp.com/api/login', body: {
        'username': credentials['username'],
        'password': credentials['password']
      }).catchError((err) => 'error');
      return res == 'error' ? 'error' : res.body;
    } else {
      return 'Not Valid';
    }
  }
}

