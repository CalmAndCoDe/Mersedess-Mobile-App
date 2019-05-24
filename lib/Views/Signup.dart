import 'dart:io';
import 'package:flutter/material.dart';
import 'package:mobile_app/Bloc/SignUp.dart';
import 'package:mobile_app/Bloc/Third.dart';
import 'package:mobile_app/Elements/EmailConfirm.dart';
import 'package:mobile_app/Elements/First.dart';
import 'package:mobile_app/Elements/ImageSelector.dart';
import 'package:mobile_app/Elements/Second.dart';
import 'package:mobile_app/Elements/Third.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';


class Signup extends StatefulWidget {
  final login;

  const Signup({Key key, this.login}) : super(key: key);
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> with SingleTickerProviderStateMixin {
  PageController _pageController;
  AnimationController _animationController;
  Animation<Offset> _logo;
  var steps = 0;
  var instance = SignUpUser.instance();
  var third = ThirdCreate.instance();

  @override
  void initState() {
    _pageController = PageController(
      initialPage: steps,
      keepPage: true,
    );
    Future.sync(() async {
      var storage = await SharedPreferences.getInstance();
      var st = storage.getInt('steps') ?? 0;
      steps = st;
      _pageController.animateToPage(steps,
          curve: Curves.easeInCirc, duration: Duration(milliseconds: 500));
    });
    instance.pageSetter = _pageController;
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 3000));

    _logo =
        Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0)).animate(
      CurvedAnimation(
          curve: Interval(0.0, 0.300, curve: Curves.easeInCirc),
          parent: _animationController),
    );
    _animationController.forward();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            FractionallySizedBox(
              heightFactor: .7,
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.only(left: 32.0, right: 32.0),
                child: PageView(
                  scrollDirection: Axis.horizontal,
                  controller: _pageController,
                  physics: NeverScrollableScrollPhysics(),
                  children: <Widget>[
                    First(
                      mainSlider: widget.login,
                    ),
                    EmailConfirmation(),
                    Second(),
                    Third()
                  ],
                ),
              ),
            ),
            FractionallySizedBox(
              heightFactor: .3,
              alignment: Alignment.topCenter,
              child: SlideTransition(
                position: _logo,
                child: Container(
                  constraints: BoxConstraints.expand(),
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.only(bottomRight: Radius.circular(99)),
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).textTheme.body2.color.withOpacity(.8),
                      ],
                      begin: FractionalOffset(-0.5, -0.5),
                      end: FractionalOffset(1.0, 1.0),
                    ),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.all(8.0),
                        alignment: Alignment.bottomLeft,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Sign Up',
                              style: TextStyle(
                                  fontFamily: 'Great Vibes',
                                  fontSize: 40,
                                  color: Theme.of(context).primaryColor),
                            ),
                            Text(
                              'Create an Account',
                              style: TextStyle(
                                  fontFamily: 'Open Sans Condensed',
                                  color: Theme.of(context).primaryColor),
                            ),
                          ],
                        ),
                      ),
                      ValueListenableBuilder(
                        valueListenable: third.selector,
                        builder: (context, value, child) {
                          if (value) {
                            return Align(
                              alignment: AlignmentDirectional.bottomEnd,
                              child: GestureDetector(
                                onTap: () {
                                  _loadImage();
                                },
                                child: ImageSelector(
                                  image: third.imageGet,
                                ),
                              ),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _loadImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    third.loadUrl = image;
    setState(() {
      print(image);
    });
  }
}
