import 'dart:async';
import 'package:http/http.dart';
import 'dart:convert';

enum Rooms { Fetch }

class RoomsFetch {
  dynamic rooms = List();

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
      rooms = await RoomsFetchMethods().getRooms();
    }
    roomsIn.add(rooms);
  }
}

class RoomsFetchMethods {
  getRooms() async {
    var rooms = await get('https://mersedess-beta.herokuapp.com/api/main');
    List roomsJson = jsonDecode(rooms.body);
    List allRooms = List();
    roomsJson.forEach(
      (element) {
        allRooms.add(Deserialzer.fromJson(element['id'], element['rooms'],
            element['title'], element['image'],element['details']));
      },
    );
    return allRooms ?? 'not available';
  }
}

class Deserialzer {
  var id;
  var rooms;
  var title;
  var image;
  var details;

  Deserialzer.fromJson(id, rooms, title, image,details) {
    this.id = id;
    this.rooms = rooms;
    this.title = title;
    this.image = image;
    this.details = details;
  }
}
