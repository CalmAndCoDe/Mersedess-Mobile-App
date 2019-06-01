import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'dart:ui' as ui;

enum Rooms { Fetch }

class MainFetch {
  List rooms = List();
  var propic;
  BuildContext context;

  set setContext(getcontext) {
    context = getcontext;
  }


  StreamController roomsState = StreamController.broadcast();
  StreamSink get roomsIn => roomsState.sink;
  Stream get roomsStream => roomsState.stream;

  StreamController roomsEvents = StreamController();
  Sink get roomsEvent => roomsEvents.sink;

  dispose() {
    roomsEvents.close();
    roomsState.close();
  }

  MainFetch() {
    roomsEvents.stream.listen(_mapEventToState);
  }

  static final _getInstance = MainFetch();
  factory MainFetch.instance() {
    return _getInstance;
  }

  _mapEventToState(event) async {
    if (event is Rooms) {
      var roomsJson = await RoomsFetchMethods().getRooms(context);
      propic = roomsJson['ProPic'];
      rooms.clear();
      roomsJson['Rooms'].forEach((room) async {
        var cachedImage = await DiskCache().load(room['id'].toString(),
            rule: CacheRule(maxAge: Duration(days: 7)));
        if (cachedImage != null) {
          var codec = await ui.instantiateImageCodec(cachedImage);
          var frame = await codec.getNextFrame();
          rooms.add(Deserialzer.fromJson(room['id'], room['rooms'],
              room['title'], frame.image, room['details'], cachedImage));
              roomsState.add(rooms);
        } else {
          var networkImage = NetworkImage(
              'https://mersedess-beta.herokuapp.com${room['image']}');
          networkImage.obtainKey(ImageConfiguration()).then((image) {
            image.load(image).addListener((bytes, loaded) async {
              var byte =
                  await bytes.image.toByteData(format: ui.ImageByteFormat.png);
              var list = byte.buffer.asUint8List();
              await DiskCache().save(room['id'].toString(), list,
                  CacheRule(maxAge: Duration(days: 7)));
              rooms.add(Deserialzer.fromJson(room['id'], room['rooms'],
                  room['title'], bytes.image, room['details'], list));
              roomsState.add(rooms);
            });
          });
        }
      });
    }
  }
}

class RoomsFetchMethods {
  Future getRooms(context) async {
    var token = await FlutterSecureStorage().read(key: 'access_token');
    var rooms = await get('https://mersedess-beta.herokuapp.com/api/main');
    var profilePic = await post(
        'https://mersedess-beta.herokuapp.com/api/auth/userpic',
        headers: {
          'Authorization': token,
        });
    List roomsJson = jsonDecode(rooms.body);
    return {'Rooms': roomsJson, 'ProPic': profilePic.body};
  }
}

class Deserialzer {
  var id;
  var rooms;
  var title;
  var image;
  var details;
  Uint8List imageData;

  Deserialzer.fromJson(id, rooms, title, image, details, imageData) {
    this.id = id;
    this.rooms = rooms;
    this.title = title;
    this.image = image;
    this.details = details;
    this.imageData = imageData;
  }
}
