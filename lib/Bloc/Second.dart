import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:mobile_app/Bloc/SignUp.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

import 'package:mobile_app/Bloc/Third.dart';

enum Pages { Previous }

class SecondCreate {
  bool success = false;
  var errors = '';
  final loading = ValueNotifier(false);
  final PageController pageController = SignUpUser().pageGetter;
    var third = ThirdCreate.instance();

  final StreamController secondState = StreamController.broadcast();
  StreamSink get secondIn => secondState.sink;
  Stream get secondStream => secondState.stream;

  final StreamController secondEvents = StreamController();
  Sink get secondEvent => secondEvents.sink;

  dispose() {
    secondEvents.close();
    secondState.close();
  }

  SecondCreate() {
    secondEvents.stream.listen(_mapEventToState);
  }

  static final getInstance = SecondCreate();
  factory SecondCreate.instance() => getInstance;

  _mapEventToState(event) async {
    if (event is Create) {
      loading.value = true;
      var res = await Create(event.credentials).create();
      loading.value = false;
      if (res == 'error') {
        errors = 'Please enter valid inputs';
        success = false;
      } else {
        PageController page = SignUpUser.instance().pageGetter;
        third.selector.value = true;
        page.nextPage(
            curve: Curves.easeInCirc, duration: Duration(milliseconds: 500));
        success = true;
      }
      secondEvents.add(success);
    }
  }
}

class Create {
  final credentials;

  Create(this.credentials);

  create() async {
    var token = await FlutterSecureStorage().read(key: 'access_token') ?? false;
    if (token != false) {
      var res = await post("https://mersedess-beta.herokuapp.com/api/user/profile",
          headers: {
            'Authorization': token
          },
          body: {
            'firstName': credentials['firstName'],
            'lastName': credentials['lastName'],
            'age': credentials['age'],
            'birthdate': credentials['birthdate'].toString(),
            'gender': credentials['gender'],
            'job': credentials['job']
          });
      if (res.body == 'no token or expired') {
        PageController page = SignUpUser.instance().pageGetter;
        page.previousPage(
            curve: Curves.easeInCirc, duration: Duration(milliseconds: 500));
      } else {
        var resJson;
        try {
          resJson = jsonDecode(res.body);
        } catch (e) {
          resJson = {
            'data' : res
          };
        }
        return resJson;
      }
    }
  }
}
