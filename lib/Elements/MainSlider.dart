import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_app/Bloc/Main.dart';
import 'package:mobile_app/Views/Room.dart';

class MainSlider extends StatefulWidget {
  const MainSlider({Key key}) : super(key: key);
  @override
  MainSliderState createState() => MainSliderState();
}

class MainSliderState extends State<MainSlider>
    with SingleTickerProviderStateMixin {
  var roomsFetch = MainFetch.instance();
  bool toggled = false;
  int currentPage = 0;
  List cacheImage = List();
  PageController _pageController;
  AnimationController _animationController;

  @override
  void initState() {
    roomsFetch.setContext = context;
    _pageController =
        PageController(initialPage: 0, keepPage: true, viewportFraction: 0.78);
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 800));
    _animationController.forward();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
        key: widget.key,
        child: StreamBuilder(
          stream: roomsFetch.roomsStream,
          initialData: roomsFetch.rooms,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return Stack(children: [
                PageView.builder(
                  controller: _pageController,
                  physics: BouncingScrollPhysics(),
                  onPageChanged: (page) => currentPage = page,
                  itemBuilder: (context, index) => _pageAnimator(
                      index,
                      MediaQuery.of(context).size.height.toInt(),
                      snapshot.data[index]),
                  itemCount: snapshot.data.length,
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
                ),
              ]);
            } else {
              return Center(
                  child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).textTheme.body2.color,
              ));
            }
          },
        ));
  }


  dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  _pageAnimator(int page, int screenHeight, Deserialzer list) {
    return AnimatedBuilder(
      key: UniqueKey(),
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
                  onTap: () => list.image != null
                      ? Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Room(
                                  imageTag: 'item-$page',
                                  textTag: 'item-text-$page',
                                  image: list.image,
                                  roomDetails: list,
                                ),
                          ))
                      : Future(() {
                          var platform = MethodChannel('android-toast');
                          platform.invokeMethod(
                              'showToast', {"message": "Image Not Loaded Yet"});
                        }),
                  child: Hero(
                    tag: 'item-$page',
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(70),
                      child: Container(
                        decoration:
                            BoxDecoration(color: Colors.white, boxShadow: [
                          BoxShadow(
                              blurRadius: 20,
                              offset: Offset(0.0, 0.0),
                              color: Colors.black.withOpacity(.05)),
                        ]),
                        child: AnimatedContainer(
                          child: Image.memory(
                            list.imageData,
                            fit: BoxFit.cover,
                            alignment:
                                FractionalOffset((value.abs() / 4) ?? 0.0, 0.0),
                          ),
                          duration: Duration(milliseconds: 100),
                          constraints: BoxConstraints.expand(
                              height: animation * screenHeight * .50,
                              width: MediaQuery.of(context).size.width * .70),
                        ),
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
