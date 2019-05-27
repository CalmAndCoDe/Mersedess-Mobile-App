import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_app/Bloc/Main.dart';
import 'package:mobile_app/Bloc/Rooms.dart';
import 'package:mobile_app/Elements/Button.dart';
import 'package:mobile_app/Functions/IconRating.dart';
import 'package:mobile_app/Functions/Sequencer.dart';
import 'package:mobile_app/Painter/ImagePainter.dart';
import 'dart:convert';

class Room extends StatefulWidget {
  final imageTag;
  final textTag;
  final details;
  final image;
  final Deserialzer roomDetails;

  const Room(
      {Key key,
      this.imageTag,
      this.details,
      this.image,
      this.textTag,
      this.roomDetails})
      : super(key: key);

  @override
  _RoomState createState() => _RoomState();
}

class _RoomState extends State<Room> with SingleTickerProviderStateMixin {
  var key;
  var imageFrame;
  bool fullScreen = false;
  var fullScreenState = ValueNotifier(false);
  var xCoordinate = ValueNotifier(0.0);
  var roomsFetch = MainFetch.instance();
  ImageInfo imageInfo;
  AnimationController _animationController;
  StreamSubscription _streamSubscription;
  static const EventChannel accelerometer = EventChannel('android-sensor');
  Stream<dynamic> get _accelerometerEvents {
    return accelerometer.receiveBroadcastStream();
  }

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    try {
      _streamSubscription.cancel();
    } catch (e) {
      print('stream already closed');
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            child: Hero(
              tag: widget.imageTag,
              child: Container(
                  constraints: BoxConstraints.expand(),
                  child: AnimatedBuilder(
                    animation: xCoordinate,
                    builder: (context, child) {
                      return CustomPaint(
                        isComplex: true,
                        painter: ImagePainter(
                            image: widget.image,
                            height: 768.0,
                            width: 1080.0,
                            xCoordinate: xCoordinate.value),
                      );
                    },
                  )),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                margin: EdgeInsets.only(left: 16.0, top: 8.0, right: 16.0),
                alignment: Alignment.center,
                width: double.infinity,
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Theme.of(context).backgroundColor,
                        ),
                      ),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: _fullScreen,
                      child: Container(
                          padding: EdgeInsets.all(8.0),
                          child: ValueListenableBuilder(
                            valueListenable: fullScreenState,
                            builder: (context, state, child) {
                              if (state) {
                                return Icon(Icons.fullscreen_exit,
                                    color: Theme.of(context).backgroundColor);
                              } else {
                                return Icon(Icons.panorama_horizontal,
                                    color: Theme.of(context).backgroundColor);
                              }
                            },
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SlideTransition(
                  position: sequencer(
                      _animationController, 0.0, .600, Curves.easeInOutCirc),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                          height: 80,
                          width: MediaQuery.of(context).size.width - 50,
                          color: Colors.white.withOpacity(.8),
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Text(
                                          widget.roomDetails.title,
                                          style: TextStyle(
                                              fontFamily: 'Open Sans Condensed',
                                              fontSize: 24,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'Rooms: ${widget.roomDetails.rooms}',
                                          style: TextStyle(
                                            fontFamily: 'Open Sans Condensed',
                                          ),
                                        )
                                      ],
                                    ),
                                    IconRate().rate(
                                        context, widget.roomDetails.rooms, 16)
                                  ],
                                ),
                                InkWell(
                                  onTap: () async {
                                    var res = await GetRooms()
                                        .reserve(widget.roomDetails.id);
                                    // remove the room from fetched rooms array
                                    roomsFetch.rooms.removeWhere((room) =>
                                        room.id == widget.roomDetails.id);
                                    roomsFetch.roomsEvents.add(Rooms.Fetch);
                                    if (res == 'done')
                                      Navigator.of(context).pop(context);
                                  },
                                  child: Button(
                                    height: 30,
                                    width: 80,
                                    child: Text(
                                      'BOOK',
                                      style: TextStyle(
                                          color: Theme.of(context)
                                              .backgroundColor),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 8.0),
                  child: SlideTransition(
                    position: sequencer(
                        _animationController, 0.500, 1.0, Curves.easeInOutCirc),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Container(
                          padding: EdgeInsets.all(16.0),
                          width: MediaQuery.of(context).size.width - 50,
                          color: Colors.white.withOpacity(.8),
                          child: Text(
                            widget.roomDetails.details,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _fullScreen() {
    if (_animationController.isCompleted && !_animationController.isAnimating) {
      _animationController.reverse().orCancel;
    }
    fullScreenState.value = !fullScreenState.value;
    if (!fullScreenState.value) {
      _streamSubscription.cancel();
      _animationController.forward();
    } else {
      _streamSubscription = _accelerometerEvents.listen((event) {
        xCoordinate.value = event;
      });
    }
  }
}
