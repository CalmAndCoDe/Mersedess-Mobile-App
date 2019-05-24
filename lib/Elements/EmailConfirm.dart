import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_app/Bloc/SignUp.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmailConfirmation extends StatefulWidget {
  final credentials;
  const EmailConfirmation({Key key, this.credentials}) : super(key: key);

  @override
  _EmailConfirmationState createState() => _EmailConfirmationState();
}

class _EmailConfirmationState extends State<EmailConfirmation> {
  PageController page = SignUpUser.instance().pageGetter;
  var email = Email.instance();
  var storage;

  @override
  void initState() {
    Future(() async {
      storage = await SharedPreferences.getInstance();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Thank You',
                style: TextStyle(
                    fontSize: 40,
                    fontFamily: 'Open Sans Condensed',
                    fontWeight: FontWeight.bold),
              ),
              Text(
                  'an email was sent to your email address and you should confirm your email before continue\nwhen you were ready you can continue by clicking this button'),
              Container(
                margin: EdgeInsets.only(top: 32.0),
                child: ValueListenableBuilder(
                  valueListenable: email.errors,
                  builder: (context, value, child) {
                    if (value.length > 0) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.warning,
                            color: Theme.of(context).textTheme.body2.color,
                          ),
                          Text(
                            'Your email isn\'t confirmed yet',
                            style: TextStyle(
                                fontFamily: 'Open Sans Condensed',
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).textTheme.body2.color),
                          ),
                        ],
                      );
                    } else {
                      return Text('');
                    }
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  ValueListenableBuilder(
                    valueListenable: email.loading,
                    builder: (context, value, child) {
                      if (value) {
                        return Container(
                          width: 60,
                          height: 60,
                          padding: EdgeInsets.all(8.0),
                          margin: EdgeInsets.only(top: 32.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(22),
                            color: Theme.of(context).textTheme.body2.color,
                          ),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      } else {
                        return GestureDetector(
                          onTap: () async {
                            email.errors.value = '';
                            var res = await email.emailConfirm();
                            print(res);
                            if (res == 'login failed' || res == 'not valid') {
                              email.errors.value = 'error';
                            } else {
                              var resJson = jsonDecode(res);
                              FlutterSecureStorage().write(key: 'access_token',value: resJson['token']);
                              page.nextPage(
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.easeInCirc);
                            }
                          },
                          child: Container(
                            width: 60,
                            height: 60,
                            padding: EdgeInsets.all(8.0),
                            margin: EdgeInsets.only(top: 32.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(22),
                              color: Theme.of(context).textTheme.body2.color,
                            ),
                            child: Center(
                              child: Icon(
                                FontAwesomeIcons.longArrowAltRight,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
