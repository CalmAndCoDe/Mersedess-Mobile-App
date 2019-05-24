import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_app/Bloc/SignUp.dart';
import 'package:mobile_app/Elements/Custombutton.dart';
import 'package:mobile_app/Elements/TextFieldBuilder.dart';
import 'package:mobile_app/Functions/Sequencer.dart';

class First extends StatefulWidget {
  final PageController mainSlider;

  const First({Key key, this.mainSlider}) : super(key: key);

  @override
  _FirstState createState() => _FirstState();
}

class _FirstState extends State<First> with SingleTickerProviderStateMixin {
  String _username;
  String _email;
  String _password;
  String _confirmPassword;
  AnimationController _animationController;
  Animation<Offset> _textFieldAnimation;

  var signup = SignUpUser.instance();

  @override
  void initState() {
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 3000));

    _textFieldAnimation =
        Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0))
            .animate(_animationController);

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
      child: ListView(
        scrollDirection: Axis.vertical,
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          StreamBuilder(
            stream: signup.signUpStream,
            initialData: signup.signUpSuccess,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (signup.signUpErrors.length > 0) {
                  return Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(8.0),
                        child: TextFieldBuilder(
                          context: context,
                          text: 'Username :',
                          isError: true,
                          error: signup.signUpErrors != 'Passwords not match'
                              ? signup.signUpErrors
                              : null,
                          icon: FontAwesomeIcons.userCircle,
                          onChanged: (value) => _username = value,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(8.0),
                        child: TextFieldBuilder(
                          context: context,
                          text: 'Email :',
                          icon: FontAwesomeIcons.envelope,
                          onChanged: (value) => _email = value,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(8.0),
                        child: TextFieldBuilder(
                          context: context,
                          text: 'Password :',
                          error: signup.signUpErrors == 'Passwords not match'
                              ? signup.signUpErrors
                              : null,
                          isError: true,
                          isPassword: true,
                          icon: Icons.lock_outline,
                          onChanged: (value) => _password = value,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(8.0),
                        child: TextFieldBuilder(
                          context: context,
                          text: 'Confirm Password :',
                          error: signup.signUpErrors == 'Passwords not match'
                              ? signup.signUpErrors
                              : null,
                          isPassword: true,
                          isError: true,
                          icon: Icons.lock_outline,
                          onChanged: (value) => _confirmPassword = value,
                        ),
                      ),
                    ],
                  );
                } else {
                  return Column(
                    children: <Widget>[
                      SlideTransition(
                        position: sequencer(_animationController, 0.0, .300,
                            Curves.easeInOutCirc),
                        child: Container(
                          margin: EdgeInsets.all(8.0),
                          child: TextFieldBuilder(
                            context: context,
                            text: 'Username :',
                            icon: FontAwesomeIcons.userCircle,
                            onChanged: (value) => _username = value,
                          ),
                        ),
                      ),
                      SlideTransition(
                        position: sequencer(_animationController, 0.100, .400,
                            Curves.easeInOutCirc),
                        child: Container(
                          margin: EdgeInsets.all(8.0),
                          child: TextFieldBuilder(
                            context: context,
                            text: 'Email :',
                            icon: FontAwesomeIcons.envelope,
                            onChanged: (value) => _email = value,
                          ),
                        ),
                      ),
                      SlideTransition(
                        position: sequencer(_animationController, 0.200, .500,
                            Curves.easeInOutCirc),
                        child: Container(
                          margin: EdgeInsets.all(8.0),
                          child: TextFieldBuilder(
                            context: context,
                            text: 'Password :',
                            isPassword: true,
                            icon: Icons.lock_outline,
                            onChanged: (value) => _password = value,
                          ),
                        ),
                      ),
                      SlideTransition(
                        position: sequencer(_animationController, 0.300, .600,
                            Curves.easeInOutCirc),
                        child: Container(
                          margin: EdgeInsets.all(8.0),
                          child: TextFieldBuilder(
                            context: context,
                            text: 'Confirm Password :',
                            isPassword: true,
                            icon: Icons.lock_outline,
                            onChanged: (value) => _confirmPassword = value,
                          ),
                        ),
                      ),
                    ],
                  );
                }
              }
            },
          ),
          SlideTransition(
            position: sequencer(_animationController, 0.400, 0.600,Curves.easeInOutCirc),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                GestureDetector(
                  onTap: () => widget.mainSlider.previousPage(
                      curve: Curves.easeInOutCirc,
                      duration: Duration(milliseconds: 1000)),
                  child: Container(
                    width: 60,
                    height: 60,
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Center(
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Theme.of(context).textTheme.body2.color,
                          fontFamily: 'Open Sans Condensed',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                ValueListenableBuilder(
                  valueListenable: signup.loading,
                  builder: (context, loading, child) {
                    if (loading) {
                      return CustomButton(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return GestureDetector(
                          onTap: () {
                            if (_password == _confirmPassword) {
                              signup.signUpEvents.add(CreateUser({
                                'username': _username,
                                'email': _email,
                                'password': _password
                              }));
                            } else {
                              signup.signUpEvents.add('Not Match');
                              signup.signUpErrors = 'Passwords not match';
                            }
                          },
                          child: CustomButton(
                            child: Icon(
                              FontAwesomeIcons.longArrowAltRight,
                              color: Theme.of(context).primaryColor,
                            ),
                          ));
                    }
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

}
