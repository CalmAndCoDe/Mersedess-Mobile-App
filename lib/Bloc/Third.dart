import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' show post, MultipartFile;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mobile_app/Bloc/LoginUser.dart';

class ThirdCreate {
  bool success = false;
  String errors = '';
  var loading = ValueNotifier(false);
  var selector = ValueNotifier(false);

  final StreamController thirdState = StreamController.broadcast();
  StreamSink get thirdIn => thirdState.sink;
  Stream get thirdStream => thirdState.stream;

  final StreamController thirdEvents = StreamController();
  Sink get thirdEvent => thirdEvents.sink;

  static final _getInstance = ThirdCreate();
  factory ThirdCreate.instance() {
    return _getInstance;
  }

  dispose() {
    thirdEvents.close();
    thirdState.close();
  }

  static File _imageUrl;

  get imageGet => _imageUrl;
  set loadUrl(File param) {
    _imageUrl = param;
  }

  ThirdCreate() {
    thirdEvents.stream.listen(_mapEventsToState);
  }

  _mapEventsToState(event) async {
    if (event is Create) {
      loading.value = true;
      var res = await Create(event.credentials, imageUrl: _imageUrl).create();
      loading.value = false;
      var resValue = jsonDecode(res);
      if (resValue == 'empty fields') {
        success = false;
        errors = 'Empty Fields';
      } else {
        var token = resValue['token'] ?? 'not available';
        FlutterSecureStorage().write(key: 'login', value: 'true');
        if (token != 'not availabe') {
          FlutterSecureStorage().write(key: 'access_token', value: token);
        }
        var login = LoginUser.instance();
        login.loginEvents.add(Done.UserCreate);
      }
    }
  }
}

class Create {
  final credentials;
  final File imageUrl;

  Create(this.credentials, {this.imageUrl});
  create() async {
    var token = await FlutterSecureStorage().read(key: 'access_token');
    if (credentials['nationality'] != null &&
        credentials['nationalId'] != null) {
      var request = MultipartRequest(
          'POST', Uri.parse('https://mersedess-beta.herokuapp.com/api/user/detail'));
      request.headers['Authorization'] = token;
      request.headers['content-type'] = 'multipart/form-data';
      request.fields['nationality'] = credentials['nationality'];
      request.fields['nationalId'] = credentials['nationalId'];
      var file = await MultipartFile.fromPath('image', imageUrl.path,
          contentType: MediaType.parse('image/jpeg'));
      request.files.add(file);
      StreamedResponse res = await request.send();
      var resValue = await res.stream.bytesToString();
      return resValue;
    } else {
      return 'empty fields';
    }
  }
}
