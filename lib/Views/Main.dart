import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_app/Bloc/Main.dart';
import 'package:mobile_app/Elements/AppBar.dart';
import 'package:mobile_app/Elements/MenuItemBuilder.dart';
import 'dart:math';

import 'package:mobile_app/Views/Room.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  bool toggled = false;
  int currentPage = 0;
  var appbar = CustomAppBar.getInstance();
  var menuSelected = ValueNotifier('home');
  var roomsFetch = RoomsFetch.instance();
  List cacheImage = List();
  PageController _pageController;
  AnimationController _animationController;
  Animation<Offset> _animation;
  AnimationController _menuAnimationController;

  @override
  void initState() {
    roomsFetch.roomsEvents.add(Rooms.Fetch);
    _pageController =
        PageController(initialPage: 0, keepPage: false, viewportFraction: 0.78);
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    _animation = Tween<Offset>(begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
        .animate(CurvedAnimation(
            curve: Curves.easeInCubic, parent: _animationController));
    _animationController.forward();
    _menuAnimationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    appbar.menuController = _menuAnimationController;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: Colors.black87,
            height: MediaQuery.of(context).size.width * .20,
            child: ListView(
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                shrinkWrap: false,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CustomMenuItem(
                        isMenuButton: true,
                        onTap: () {
                          appbar.menuState.value
                              ? _menuAnimationController.reverse().orCancel
                              : _menuAnimationController.forward().orCancel;
                          appbar.menuState.value = !appbar.menuState.value;
                        },
                        itemColor: Theme.of(context).textTheme.body2.color,
                        child: Icon(
                          Icons.arrow_downward,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      ValueListenableBuilder(
                        valueListenable: menuSelected,
                        builder: (context, menu, child) {
                          return Row(
                            children: <Widget>[
                              CustomMenuItem(
                                onTap: () => menuSelected.value = 'home',
                                isSelected: menu == 'home',
                                isMenuButton: false,
                                itemColor:
                                    Theme.of(context).textTheme.body2.color,
                                child: Icon(
                                  Icons.home,
                                  color:
                                      Theme.of(context).textTheme.body2.color,
                                ),
                              ),
                              CustomMenuItem(
                                onTap: () => menuSelected.value = 'bookmark',
                                isSelected: menu == 'bookmark',
                                itemColor:
                                    Theme.of(context).textTheme.body2.color,
                                child: Icon(
                                  Icons.bookmark_border,
                                  color:
                                      Theme.of(context).textTheme.body2.color,
                                ),
                              ),
                              CustomMenuItem(
                                onTap: () => menuSelected.value = 'profile',
                                isSelected: menu == 'profile',
                                itemColor:
                                    Theme.of(context).textTheme.body2.color,
                                child: Icon(
                                  FontAwesomeIcons.userCircle,
                                  color:
                                      Theme.of(context).textTheme.body2.color,
                                ),
                              ),
                              CustomMenuItem(
                                onTap: () => menuSelected.value = 'logout',
                                isSelected: menu == 'logout',
                                itemColor:
                                    Theme.of(context).textTheme.body2.color,
                                child: Icon(
                                  FontAwesomeIcons.signOutAlt,
                                  color:
                                      Theme.of(context).textTheme.body2.color,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ]),
          ),
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
            body: Stack(
              children: [
                SlideTransition(
                  position: _animation,
                  child: StreamBuilder(
                    stream: roomsFetch.roomsStream,
                    initialData: roomsFetch.rooms,
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return PageView.builder(
                          controller: _pageController,
                          physics: BouncingScrollPhysics(),
                          onPageChanged: (page) => currentPage = page,
                          itemBuilder: (context, index) => _pageAnimator(
                              index,
                              MediaQuery.of(context).size.height.toInt(),
                              snapshot.data[index]),
                          itemCount: snapshot.data.length,
                        );
                      }
                        return Center(child: CircularProgressIndicator(
                          backgroundColor: Theme.of(context).textTheme.body2.color,
                        ));
                    },
                  ),
                ),
                Align(
                  alignment: FractionalOffset(0.9, 0.83),
                  child: AnimatedBuilder(
                    animation: _pageController,
                    builder: (context, child) {
                      var page;
                      var firstDigit;
                      double animation;
                      try {
                        page = _pageController.page.floor().toString();
                        animation = _pageController.page - currentPage;
                      } catch (e) {
                        animation = _pageController.initialPage.toDouble() -
                            currentPage;
                        page = _pageController.initialPage.toString();
                      }
                      // all of indexes
                      var matchRegex = RegExp(r'(\d)')
                          .allMatches(page)
                          .map((element) => element.group((1)));
                      // firt index of numbers
                      var digitRegex = RegExp(r'(\d)').firstMatch(page);
                      bool prefixEqual = matchRegex.length > 1 &&
                          matchRegex.first == digitRegex.group(1);
                      firstDigit = digitRegex.group((1));
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            transform: Matrix4.identity()
                              ..rotateX((pi / 180) * (-animation * 50) - 7),
                            child: Text(
                              currentPage != 0
                                  ? ((currentPage - 1) + 1).toString()
                                  : '',
                              style: TextStyle(
                                  fontFamily: 'Open Sans Condensed',
                                  color:
                                      Theme.of(context).textTheme.body1.color),
                            ),
                          ),
                          Container(
                            transform: Matrix4.identity()
                              ..setTranslationRaw(0, -animation * 25, 0)
                              ..rotateX((pi / 180) * (animation * 100)),
                            child: Text(
                              (currentPage + 1).toString(),
                              style: TextStyle(
                                  fontFamily: 'Open Sans Condensed',
                                  color:
                                      Theme.of(context).textTheme.body1.color),
                            ),
                          ),
                          Container(
                            transform: Matrix4.identity()
                              ..setEntry(2, 2, 0.00010)
                              ..rotateX((pi / 180) * (animation * 50) - 7),
                            child: Text(
                              (currentPage + 1) <= roomsFetch.rooms.length - 1
                                  ? (currentPage + 2).toString()
                                  : '',
                              style: TextStyle(
                                  fontFamily: 'Open Sans Condensed',
                                  color:
                                      Theme.of(context).textTheme.body1.color),
                            ),
                          )
                        ],
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  _pageAnimator(int page, int screenHeight, Deserialzer list) {
    return AnimatedBuilder(
      animation: _pageController,
      builder: (context, child) {
        double animation = 1.0;
        double value = 0;
        if (_pageController.position.haveDimensions) {
          value = page - _pageController.page;
          animation = (1 - value.abs() * .200).clamp(0.0, 1.0);
        }

        return ListView(
          physics: BouncingScrollPhysics(),
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  onTap: () => cacheImage != null
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Room(
                                  imageTag: 'item-$page',
                                  textTag: 'item-text-$page',
                                  image: cacheImage[page],
                                ),
                          ))
                      : Future(() {
                          var platform = MethodChannel('android-toast');
                          platform.invokeMethod(
                              'showToast', {"message": "Image Not Loaded Yet"});
                        }),
                  child: Hero(
                    tag: 'item-$page',
                    child: Container(
                      margin: EdgeInsets.only(top: 16.0),
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              alignment: FractionalOffset(
                                  (value.abs() / 4) ?? 0.0, 0.0),
                              fit: BoxFit.cover,
                              image: AdvancedNetworkImage(
                                  'https://mersedess-beta.herokuapp.com/${list.image}',
                                  useDiskCache: true,
                                  postProcessing: (Uint8List list) async {
                                var codec =
                                    await ui.instantiateImageCodec(list);
                                var image = await codec.getNextFrame();
                                cacheImage.add(image.image);
                              },
                                  retryDuration: Duration(seconds: 3),
                                  cacheRule:
                                      CacheRule(maxAge: Duration(days: 7)))),
                          borderRadius: BorderRadius.circular(70),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                blurRadius: 20,
                                offset: Offset(0.0, 0.0),
                                color: Colors.black.withOpacity(.05)),
                          ]),
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 100),
                        constraints: BoxConstraints.expand(
                            height: animation * screenHeight * .50,
                            width: MediaQuery.of(context).size.width * .70),
                      ),
                    ),
                  ),
                ),
                Container(
                  transform: Matrix4.translationValues(
                      0, value.abs() * screenHeight * .50, 0),
                  margin: EdgeInsets.only(top: 16.0, left: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 16.0, bottom: 16.0),
                        child: Hero(
                          tag: 'item-text-$page',
                          transitionOnUserGestures: true,
                          child: Text(
                            list.title,
                            style: TextStyle(
                                fontFamily: 'Open Sans Condensed',
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          list.details,
                          style: TextStyle(
                            fontFamily: 'Open Sans Condensed',
                            fontSize: 14,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ],
        );
      },
    );
  }
}
