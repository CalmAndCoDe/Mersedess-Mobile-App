import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

enum Authenticate { FingerPrint, Passcode }

// for local authentication with biometric or passcode
class Authentication {
  bool authenticated = false;
  final StreamController authStates = StreamController.broadcast();
  StreamSink get authState => authStates.sink;
  Stream get authStream => authStates.stream;

  final StreamController authEvents = StreamController();
  Sink get authEvent => authEvents.sink;

  dispose() {
    authStates.close();
    authEvents.close();
  }

  Authentication() {
    authEvents.stream.listen(_mapEventToState);
  }

  static Authentication _getInstance = Authentication();
  factory Authentication.instance() {
    return _getInstance;
  }

  _mapEventToState(event) async {
    if (event is Authenticate) {
      print(event);
      var authentication = await Biometric().authenticate();
      authenticated = authentication;
    }
    authStates.add(authenticated);
  }
}

class Biometric {
  authenticate() async {
    var local = LocalAuthentication();
    bool authentication = await local.canCheckBiometrics;
    if (authentication) {
      bool succeed = await local.authenticateWithBiometrics(
        localizedReason: 'You Should be authenticate before access',
        stickyAuth: true,
      );
      print(succeed);
      switch (succeed) {
        case true:
          return true;
          break;
        case false:
          return false;
          break;
        default:
          return 'Not Supported';
          break;
      }
    }
  }

  canAuthenticate() async {
    var local = LocalAuthentication();
    var isAuthenticationAvailable = await local.canCheckBiometrics;
    switch (isAuthenticationAvailable) {
      case true:
        FlutterSecureStorage().write(key: 'authenticate' , value: 'true');
        break;
      default:
        break;
    }
  }
}
