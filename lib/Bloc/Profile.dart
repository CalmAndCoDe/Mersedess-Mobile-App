import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:mobile_app/Bloc/LoginUser.dart';

enum Profile { Fetch }

class UserProfileFetch {
  ProfileDeserializer userProfile;

  final StreamController userState = StreamController.broadcast();
  StreamSink get userIn => userState.sink;
  Stream get userStream => userState.stream;

  final StreamController userEvents = StreamController();
  Sink get userEvent => userEvents.sink;

  static final UserProfileFetch _instance = UserProfileFetch();
  factory UserProfileFetch.instance() => _instance;

  UserProfileFetch() {
    userEvents.stream.listen(_mapEventToState);
  }

  void dispose() {
    userState.close();
    userEvents.close();
  }

  void _mapEventToState(event) async {
    if (event is Profile) {
      userProfile = await FetchProfile().fetchUserProfile();
    }
    userState.add(userProfile);
  }
}

class FetchProfile {
  Future<ProfileDeserializer> fetchUserProfile() async {
    var token = await FlutterSecureStorage().read(key: 'access_token');
    var res = await post(
        'https://mersedess-beta.herokuapp.com/api/auth/reservation',
        headers: {'Authorization': token});
    
    if (res.body == 'no token or expired') {
      // push to login screen
      LoginUser.instance().loginEvents.add(Error.AuthenticationError);
      return null;
    } else {
      var resJson = jsonDecode(res.body);
      return ProfileDeserializer.fromJson(
          resJson['Profile']['first_name'],
          resJson['Profile']['last_name'],
          resJson['Profile']['gender'],
          resJson['Profile']['age'],
          resJson['Profile']['birthdate']);
    }
  }
}

class ProfileDeserializer {
  String fullName;
  String gender;
  int age;
  String birthdate;
  ProfileDeserializer.fromJson(
      String firstName, String lastName, gender, age, birthdate) {
    this.fullName =
        '${firstName.substring(0, 1).toUpperCase() + firstName.substring(1, firstName.length)} ${lastName.substring(0, 1).toUpperCase() + lastName.substring(1, lastName.length)}';
    this.gender = gender;
    this.birthdate = birthdate;
    this.age = age;
  }
}
