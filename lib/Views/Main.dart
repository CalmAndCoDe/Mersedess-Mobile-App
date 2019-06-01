import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_app/Bloc/Main.dart';
import 'package:mobile_app/Bloc/Profile.dart';
import 'package:mobile_app/Elements/AppBar.dart';
import 'package:mobile_app/Elements/BottomNavbar.dart';
import 'package:mobile_app/Elements/MainSlider.dart';
import 'package:mobile_app/Views/BookMarks.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  var appbar = CustomAppBar.getInstance();
  var menuSelected = ValueNotifier('home');
  var roomsFetch = MainFetch.instance();
  var profileFetch = UserProfileFetch.instance();
  PageStorageBucket _bucket = PageStorageBucket();
  PageStorageKey firstPage = PageStorageKey('MainPage');
  PageStorageKey secondPage = PageStorageKey('BookmarksPage');
  Animation<Offset> _animation;
  AnimationController _menuAnimationController;
  AnimationController _animationController;
  PageController _menuController;

  @override
  void initState() {
    _menuController = PageController(initialPage: 0, keepPage: true);
    roomsFetch.roomsEvents.add(Rooms.Fetch);
    profileFetch.userEvents.add(Profile.Fetch);
    _menuAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    appbar.menuController = _menuAnimationController;
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    _animation = Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
        .animate(CurvedAnimation(
            curve: Curves.easeInCubic, parent: _animationController));
    super.initState();
  }


  @override
  void dispose() {
    _menuAnimationController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Menu(
              appbar: appbar,
              menuAnimationController: _menuAnimationController,
              menuSelected: menuSelected,
              menuController: _menuController),
        ),
        SlideTransition(
          position: _menuAnimationController.drive(Tween<Offset>(
              begin: Offset(0.0, 0.0),
              end: Offset(
                0.0,
                -1 / 9.0,
              )).chain(CurveTween(curve: Curves.easeInOutCirc))),
          child: Scaffold(
            backgroundColor: Theme.of(context).backgroundColor,
            appBar: appbar.appBar(context),
            body: PageStorage(
              bucket: _bucket,
              child: PageView(
                key: PageStorageKey('PageViewer'),
                controller: _menuController,
                physics: NeverScrollableScrollPhysics(),
                children: <Widget>[
                  MainSlider(
                    key: firstPage,
                  ),
                  Bookmarks()
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
