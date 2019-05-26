import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'dart:ui' as ui;

enum Rooms { Fetch }

class RoomsFetch {
  dynamic rooms = null;
  BuildContext context;

  set setContext(getcontext) {
    context = getcontext;
  }

  static List cachedImages = List();

  StreamController roomsState = StreamController.broadcast();
  StreamSink get roomsIn => roomsState.sink;
  Stream get roomsStream => roomsState.stream;

  StreamController roomsEvents = StreamController();
  Sink get roomsEvent => roomsEvents.sink;

  dispose() {
    roomsEvents.close();
    roomsState.close();
  }

  RoomsFetch() {
    roomsEvents.stream.listen(_mapEventToState);
  }

  static final _getInstance = RoomsFetch();
  factory RoomsFetch.instance() {
    return _getInstance;
  }

  _mapEventToState(event) async {
    if (event is Rooms) {
      rooms = await RoomsFetchMethods().getRooms(context);
      print('rooms: ${rooms}');
    }
    roomsState.add(rooms);
  }
}

class RoomsFetchMethods {
  Future<List> getRooms(context) async {
    var rooms = await get('https://mersedess-beta.herokuapp.com/api/main');
    List roomsJson = jsonDecode(rooms.body);
    List allRooms = List();
    return await Future.sync(() async {
      for (var i = 0; i < roomsJson.length; i++) {
        var frame;
        var imageData;
        await precacheImage(
            AdvancedNetworkImage(
                'https://mersedess-beta.herokuapp.com/${roomsJson[i]['image']}',
                cacheRule: CacheRule(maxAge: Duration(days: 7)),
                postProcessing: (Uint8List list) async {
              imageData = list;
              var codec = await ui.instantiateImageCodec(list);
              frame = await codec.getNextFrame();
            }, useDiskCache: true),
            context);
        allRooms.add(Deserialzer.fromJson(
            roomsJson[i]['id'],
            roomsJson[i]['rooms'],
            roomsJson[i]['title'],
            frame.image,
            roomsJson[i]['details'],
            imageData));
      }
    }).then((value) {
      return allRooms ?? 'not available';
    });
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
