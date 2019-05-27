import 'dart:async';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile_app/Bloc/LoginUser.dart';

enum Get { Reserved }

class RoomActions {
  dynamic reservedRooms = List();

  StreamController reservedState = StreamController.broadcast();
  StreamSink get reservedIn => reservedState.sink;
  Stream get reservedStream => reservedState.stream;

  StreamController reservedEvents = StreamController();
  Sink get reservedEvent => reservedEvents.sink;

  RoomActions() {
    reservedEvents.stream.listen(_mapEventToState);
  }

  static final _getInstance = RoomActions();
  factory RoomActions.instance() => _getInstance;

  dispose() {
    reservedEvents.close();
    reservedState.close();
  }

  _mapEventToState(event) async {
    // request to get user reserved rooms
    if (event is Get) {
      var res = await GetRooms().getRoom();
      // if user token is expired or invalid kick-out the user to login screen
      if (res == 'not authorized') {
        var login = LoginUser.instance();
        login.loginEvents.add(Error.AuthenticationError);
      }
      reservedRooms = res;
    } else if (event is GetRooms) {
      var res = await GetRooms(roomid: event.roomid).deleteReserve();
      if (res == 'not authorized') {
        var login = LoginUser.instance();
        login.loginEvents.add(Error.AuthenticationError);
      }
    }
    reservedState.add(reservedRooms);
  }
}

class GetRooms {
  final roomid;

  GetRooms({this.roomid});
  getRoom() async {
    var token = await FlutterSecureStorage().read(key: 'access_token');
    if (token != null) {
      var res = await post(
          'https://mersedess-beta.herokuapp.com/api/auth/reservation',
          headers: {'Authorization': token});
      var resJson =
          res.body != 'no token or expired' ? jsonDecode(res.body) : null;
      if (resJson != null && resJson['Details']['Rooms'] != null) {
        FlutterSecureStorage()
            .write(key: 'access_token', value: resJson['token']);
        List rooms = resJson['Details']['Rooms'];
        Iterable<RoomDeserializer> allRooms = rooms.map((room) =>
            RoomDeserializer.fromJson(
                room['id'], room['title'], room['rooms'], room['image']));
        return allRooms.length != 0 ? allRooms : 'no reserved rooms';
      } else {
        return 'no reserved rooms';
      }
    } else {
      return 'not authorized';
    }
  }

  deleteReserve() async {
    var token = await FlutterSecureStorage().read(key: 'access_token');
    if (token != null) {
      var res = await delete(
          'https://mersedess-beta.herokuapp.com/api/room/reserve/delete/$roomid',
          headers: {'Authorization': token});
      var resJson = jsonDecode(res.body);
      if (resJson == 'no token or expired') {
        return 'not authorized';
      } else {
        FlutterSecureStorage()
            .write(key: 'access_token', value: resJson['token']);
        return roomid;
      }
    } else {
      return 'not authorized';
    }
  }

  reserve(roomid) async {
    var token = await FlutterSecureStorage().read(key: 'access_token');
    if (token != null) {
      var res = await post(
          'https://mersedess-beta.herokuapp.com/api/room/reserve',
          headers: {'Authorization': token},
          body: {
            'roomId' : roomid.toString()
          });
      var resJson = jsonDecode(res.body);
      if (resJson == 'no token or expired' || resJson['data'] == 'error') {
        return 'not authorized';
      } else {
        FlutterSecureStorage()
            .write(key: 'access_token', value: resJson['token']);
        return 'done';
      }
    } else {
      return 'not authorized';
    }
  }
}

class RoomDeserializer {
  var id;
  var title;
  var rooms;
  var image;

  RoomDeserializer.fromJson(id, title, rooms, image) {
    this.id = id;
    this.title = title;
    this.rooms = rooms;
    this.image = "https://mersedess-beta.herokuapp.com/${image}";
  }
}
