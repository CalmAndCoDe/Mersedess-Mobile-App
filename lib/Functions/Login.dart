import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LoginState {
  userLoginState() async {
    var login = await FlutterSecureStorage().read(key: 'login') ?? false;
    return login;
  }
}