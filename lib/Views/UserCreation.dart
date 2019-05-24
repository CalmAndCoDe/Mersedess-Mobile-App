import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_app/Bloc/Authentication.dart';
import 'package:mobile_app/Bloc/LoginUser.dart';
import 'package:mobile_app/Functions/Login.dart';
import 'package:mobile_app/Views/LockScreen.dart';
import 'package:mobile_app/Views/Login.dart';
import 'package:mobile_app/Views/Main.dart';
import 'package:mobile_app/Views/Signup.dart';
import 'package:mobile_app/main.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  var login = LoginUser.instance();
  var authentication = Authentication.instance();
  bool shouldAuthenticate;
  PageController _pageController;

  @override
  void initState() {
    Future.sync(() async {
      var res = await LoginState().userLoginState();
      if (res == 'true') {
        login.loginState.add(true);
      }
    });
    _pageController = PageController(
      initialPage: 0,
      keepPage: true,
    );
    super.initState();
  }


  Future<bool> _shouldAuthenticate() async {
    var res = await FlutterSecureStorage().read(key: 'authenticate');
    return res=='true' ? true : false;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: login.loginStream,
        initialData: login.isUserLoggedIn,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // change to snapshot.data for disable development mode
            if (true) {
              // User logged in
              //TODO: implement app authentication
              return FutureBuilder(
                future: _shouldAuthenticate(),
                initialData: shouldAuthenticate,
                builder: (context, authenticationEnabled) {
                  if (authenticationEnabled.hasData) {
                    if (authenticationEnabled.data) {
                      return StreamBuilder(
                        stream: authentication.authStream,
                        initialData: authentication.authenticated,
                        builder: (context, snapshot) {
                          //TODO: Implement views for authenticated and non-authenticated user
                          if (snapshot.hasData) {
                            if (true) {
                              // Main View
                              return HomeScreen();
                            } else {
                              return LockScreen();
                            }
                          }
                        },
                      );
                    } else {
                      //Main View
                      return HomeScreen();
                    }
                  }else {
                    return CircularProgressIndicator(); 
                  }
                },
              );
            } else {
              // all of user login and signup procedure
              return Scaffold(
                  backgroundColor: Theme.of(context).backgroundColor,
                  body: PageView(
                    controller: _pageController,
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    children: <Widget>[
                      Login(
                        pageController: _pageController,
                      ),
                      Signup(
                        login: _pageController,
                      )
                    ],
                  ));
            }
          }
        },
      ),
    );
  }
}
