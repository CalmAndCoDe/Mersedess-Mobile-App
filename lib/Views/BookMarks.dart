import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:mobile_app/Bloc/Rooms.dart';
import 'package:mobile_app/Elements/Button.dart';
import 'package:mobile_app/Elements/Custombutton.dart';
import 'package:mobile_app/Functions/IconRating.dart';

class Bookmarks extends StatefulWidget {
  @override
  _BookmarksState createState() => _BookmarksState();
}

class _BookmarksState extends State<Bookmarks> {
  RoomActions reservations;
  @override
  void initState() {
    reservations = RoomActions.instance();
    reservations.reservedEvents.add(Get.Reserved);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Container(
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: StreamBuilder(
        stream: reservations.reservedStream,
        initialData: reservations.reservedRooms,
        builder: (context, snapshot) {
          if (snapshot.hasData && (snapshot.data != 'no reserved rooms' && snapshot.data != 'not authorized') ) {
            Iterable rooms = snapshot.data;
            return Column(
                children: rooms
                    .map((room) => itemBuilder(
                        room.title, room.image, room.rooms, room.id))
                    .toList());
          } else if (snapshot.data == 'no reserved rooms') {
            return Container(
              child: Center(
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Image.asset(
                    'images/notfound.png',
                    color: Theme.of(context).backgroundColor,
                    colorBlendMode: BlendMode.darken,
                  ),
                  Text(
                    'Yoo, go and reserve some room :)',
                    style: TextStyle(
                        color: Theme.of(context).textTheme.body1.color,
                        fontFamily: 'Open Sans Condensed',
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ),
            );
          } else {
            return CircularProgressIndicator(
              backgroundColor: Theme.of(context).textTheme.body2.color,
            );
          }
        },
      ),
    ));
  }

  Widget itemBuilder(title, image, rooms, roomid) {
    return Material(
      color: Theme.of(context).backgroundColor,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Container(
                  width: MediaQuery.of(context).size.width * .40,
                  color: Colors.blue,
                  child: Image(
                    image: AdvancedNetworkImage(image),
                    fit: BoxFit.cover,
                    height: 100,
                  )),
            ),
            Container(
              margin: EdgeInsets.only(left: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: TextStyle(
                        fontFamily: 'Open Sans Condensed',
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                  IconRate().rate(context, rooms, 14),
                  Text(
                    'Rooms: ${rooms}',
                    style: TextStyle(
                      fontFamily: 'Open Sans Condensed',
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          reservations.reservedEvents
                              .add(GetRooms(roomid: roomid));
                          reservations.reservedEvents.add(Get.Reserved);
                        },
                        child: Button(
                          height: 30,
                          width: 80,
                          child: Text(
                            'Remove',
                            style: TextStyle(
                                color: Theme.of(context).backgroundColor),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      CustomButton(
                          child: Icon(
                            Icons.bookmark_border,
                            color: Theme.of(context).textTheme.body2.color,
                          ),
                          height: 30.0,
                          width: 30.0,
                          radius: 12,
                          color: Theme.of(context).backgroundColor,
                          boxShadow: [
                            BoxShadow(blurRadius: 20, color: Colors.black12)
                          ])
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
