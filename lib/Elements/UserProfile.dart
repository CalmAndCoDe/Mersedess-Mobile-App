import 'package:flutter/material.dart';
import 'package:flutter_advanced_networkimage/provider.dart';

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
                    if(snapshot.hasData) {
                      return Image.memory(snapshot.data);
                    }else {
                      return CircularProgressIndicator(
                        backgroundColor: Theme.of(context).textTheme.body2.color,
                      );
                    }
                  },
                ),
          )),
      )
    );
    
  }

  _loadImage() async {
    var bytes = await  DiskCache().load('proPic');
    return bytes;
  }
}
