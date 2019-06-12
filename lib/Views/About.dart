import 'package:flutter/material.dart';
import 'package:mobile_app/Elements/Button.dart';
import 'package:mobile_app/Elements/Custombutton.dart';
import 'package:mobile_app/Functions/TextStyles.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Flexible(
                flex: 3,
                child: Container(
                  constraints: BoxConstraints.expand(),
                  color: Theme.of(context).primaryColor,
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back_ios),
                        onPressed: () => Navigator.of(context).pop(context),
                        color: Theme.of(context).textTheme.body1.color,
                      ),
                      Text(
                        'About',
                        style: settingButtonStyle,
                      )
                    ],
                  ),
                ),
              ),
              Flexible(
                flex: 20,
                child: ListView(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(16.0),
                      child: Text(
                          'This is an opensource project that made by flutter with its website, feel free to use it in your next projects, also if you see any bug just send an issue to our github.You can give us star on Google Play by clicking button in below.\nMade With <3 for You.'),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 16.0),
                      child: Button(
                        onTap: () async { 
                          var url = 'https://github.com/CalmAndCoDe/Mersedess-Mobile-App';
                          if(await canLaunch(url)) {
                            await launch(url);
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Star',style: defaultStyle.copyWith(
                            color: Theme.of(context).backgroundColor
                          ),),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
