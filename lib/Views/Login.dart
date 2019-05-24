import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_app/Bloc/Authentication.dart';
import 'package:mobile_app/Bloc/LoginUser.dart';
import 'package:mobile_app/Bloc/Themes.dart';
import 'package:mobile_app/Elements/Custombutton.dart';
import 'package:mobile_app/Elements/Round.dart';
import 'package:mobile_app/Elements/TextFieldBuilder.dart';
import 'package:mobile_app/Functions/Sequencer.dart';

class Login extends StatefulWidget {
  var login = LoginUser.instance();
  var theme = ThemesChanger.instance();
  final PageController pageController;

  Login({Key key, this.pageController}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  bool selected = false;
  String _username;
  String _password;
  AnimationController _animationController;
  Animation<Offset> _logo;

  @override
  void initState() {
    Biometric().canAuthenticate();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2800),
    );

    _logo = Tween<Offset>(begin: Offset(0.0, -1.0), end: Offset(0.0, 0.0))
        .animate(CurvedAnimation(
            curve: Interval(0.0, 0.200, curve: Curves.easeInOutCirc),
            parent: _animationController));
    _animationController.forward();

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Flexible(
            flex: 1,
            child: SlideTransition(
              position: _logo,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).textTheme.body2.color.withOpacity(.8)
                      ],
                      begin: FractionalOffset(-0.5, -0.5),
                      end: FractionalOffset(1.0, 1.0)),
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(99),
                  ),
                ),
                child: Stack(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              'Login',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 48,
                                  fontFamily: 'Great Vibes'),
                            ),
                            Text(
                              'Login to your account',
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontFamily: 'Open Sans Condensed',
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: ListView(
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 32.0),
                  color: Theme.of(context).accentColor,
                  child: Column(
                    children: <Widget>[
                      StreamBuilder(
                        stream: widget.login.loginStream,
                        initialData: widget.login.isUserLoggedIn,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            if (widget.login.loginErrors.length > 0) {
                              return Column(children: <Widget>[
                                Container(
                                  margin: EdgeInsets.all(8.0),
                                  child: TextFieldBuilder(
                                    context: context,
                                    text: 'Username:',
                                    icon: FontAwesomeIcons.userCircle,
                                    isError: true,
                                    error: widget.login.loginErrors !=
                                            'Password is Wrong'
                                        ? widget.login.loginErrors
                                        : null,
                                    onChanged: (value) => _username = value,
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.all(8.0),
                                  child: TextFieldBuilder(
                                    context: context,
                                    text: 'Password :',
                                    isPassword: true,
                                    error: widget.login.loginErrors ==
                                            'Password is Wrong'
                                        ? widget.login.loginErrors
                                        : null,
                                    icon: Icons.lock_outline,
                                    isError: true,
                                    onChanged: (value) => _password = value,
                                  ),
                                ),
                              ]);
                            } else {
                              return Column(children: <Widget>[
                                Container(
                                  margin: EdgeInsets.all(8.0),
                                  child: SlideTransition(
                                    position: sequencer(_animationController, 0.200, 0.400, Curves.easeInOutCirc),
                                    child: TextFieldBuilder(
                                      context: context,
                                      text: 'Username :',
                                      icon: FontAwesomeIcons.userCircle,
                                      onChanged: (value) => _username = value,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.all(8.0),
                                  child: SlideTransition(
                                      position: sequencer(_animationController, 0.300, 0.500, Curves.easeInOutCirc),
                                      child: TextFieldBuilder(
                                        context: context,
                                        text: 'Password :',
                                        isError: false,
                                        isPassword: true,
                                        icon: Icons.lock_outline,
                                        onChanged: (value) => _password = value,
                                      )),
                                ),
                              ]);
                            }
                          } else {
                            return Container(
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                        },
                      ),
                      SlideTransition(
                        position: sequencer(_animationController, 0.400, 0.600, Curves.easeInOutCirc),
                        child: Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 8.0),
                          child: Row(
                            children: <Widget>[
                              RoundBox(
                                  tickColor: Theme.of(context).primaryColor,
                                  margin: EdgeInsets.symmetric(horizontal: 8.0),
                                  color:
                                      Theme.of(context).textTheme.body2.color,
                                  isSelected: selected,
                                  onTap: () {
                                    setState(() {
                                      selected = !selected;
                                    });
                                  }),
                              Text(
                                'Keep me logged in',
                                style: TextStyle(
                                    fontFamily: 'PT Sans',
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SlideTransition(
                  position: sequencer(_animationController, 0.500, 0.700, Curves.easeInOutCirc),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        InkWell(
                          onTap: () => widget.pageController.nextPage(
                              curve: Curves.easeInOutCirc,
                              duration: Duration(milliseconds: 1000)),
                          child: Text(
                            'Create an account',
                            style: TextStyle(
                                fontFamily: 'Open Sans Condensed',
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).textTheme.body2.color),
                          ),
                        ),
                        ValueListenableBuilder(
                          valueListenable: widget.login.loading,
                          builder: (context, value, child) {
                            if (value == 0) {
                              return GestureDetector(
                                  onTap: () => widget.login.loginEvents.add(
                                          AutheticateUser(credentials: {
                                        'username': _username,
                                        'password': _password
                                      }, shouldSaveToken: selected)),
                                  child: CustomButton(
                                    child: Icon(
                                      FontAwesomeIcons.longArrowAltRight,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ));
                            } else {
                              return GestureDetector(
                                onTap: () => widget.login.loginEvents.add(
                                        AutheticateUser(credentials: {
                                      'username': _username,
                                      'password': _password
                                    }, shouldSaveToken: selected)),
                                child: CustomButton(
                                  child: CircularProgressIndicator(),
                                )
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
