import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

class UserProfile extends StatefulWidget {
  final BuildContext context;
  final Function onTap;
  final EdgeInsets margin;

  const UserProfile({Key key, this.margin, this.context, this.onTap})
      : super(key: key);
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  var imageBytes;
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(8.0),
        margin: widget.margin,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(33),
            bottomLeft: Radius.circular(33),
          ),
          color: Theme.of(context).backgroundColor,
        ),
        child: GestureDetector(
          onTap: widget.onTap,
          child: ClipOval(
              child: Container(
            height: 40,
            width: 40,
            child: FutureBuilder(
              future: _loadImage(),
              initialData: imageBytes,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Image.memory(snapshot.data);
                } else {
                  return CircularProgressIndicator(
                    backgroundColor: Theme.of(context).textTheme.body2.color,
                  );
                }
              },
            ),
          )),
        ));
  }

  _loadImage() async {
    var token = await FlutterSecureStorage().read(key: 'access_token');
    var profilePic = await DiskCache()
        .load('proPic', rule: CacheRule(maxAge: Duration(days: 7)));
    var pic = await post(
        'https://mersedess-beta.herokuapp.com/api/auth/userpic',
        headers: {'Authorization': token, 'content-type': 'image/jpeg'});
    String imageBase64 = pic.body;
    var base64image = imageBase64.split(',');
    Uint8List image = base64.decode(base64image[1]);
    if (profilePic == image) {
      return await DiskCache()
          .load('proPic', rule: CacheRule(maxAge: Duration(days: 7)));
    } else {
      DiskCache().save('proPic', image, CacheRule(maxAge: Duration(days: 7)));
      return image;
    }
  }
}
