import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_app/Bloc/Profile.dart';
import 'package:mobile_app/Bloc/Themes.dart';
import 'package:mobile_app/Elements/SettingButton.dart';

class ProfileSettings extends StatefulWidget {
  final proPic;

  const ProfileSettings({Key key, this.proPic}) : super(key: key);
  @override
  _ProfileSettingsState createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  var userProfile = UserProfileFetch.instance();
  var themes = ThemesChanger.instance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Material(
      color: Theme.of(context).backgroundColor,
      child: Column(
        children: <Widget>[
          Flexible(
            flex: 3,
            child: Container(
              constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(99)),
              ),
              child: SafeArea(
                child: Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          IconButton(
                            icon: Icon(Icons.arrow_back_ios),
                            onPressed: () => Navigator.of(context).pop(context),
                            color: Theme.of(context).textTheme.body1.color,
                          ),
                        ],
                      ),
                    ),
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: MemoryImage(widget.proPic),
                    ),
                    StreamBuilder(
                        stream: userProfile.userStream,
                        initialData: userProfile.userProfile,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                snapshot.data.fullName.toString(),
                                style: TextStyle(
                                    fontSize: 22,
                                    fontFamily: 'Open Sans Condensed',
                                    fontWeight: FontWeight.bold),
                              ),
                            );
                          } else {
                            LinearProgressIndicator();
                          }
                        })
                  ],
                ),
              ),
            ),
          ),
          Flexible(
            flex: 5,
            child: Container(
              alignment: Alignment.center,
              child: ListView(
                children: <Widget>[
                  StreamBuilder(
                    stream: themes.themeStream,
                    initialData: themes.darkmode,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        if (themes.darkmode) {
                          return SettingButton(
                            icon: FontAwesomeIcons.toggleOn,
                            text: 'Dark Mode',
                            isSelected: themes.darkmode,
                            isTogglable: true,
                            onTap: () => themes.themeEvents.add(ThemeMode.Light),
                          );
                        } else {
                          return SettingButton(
                            icon: FontAwesomeIcons.toggleOff,
                            text: 'Dark Mode',
                            isSelected: themes.darkmode,
                            onTap: () => themes.themeEvents.add(ThemeMode.Dark),
                            isTogglable: true,
                          );
                        }
                      }
                    },
                  ),
                  SettingButton(
                    icon: Icons.lock,
                    text: 'Authentication',
                    isSelected: false,
                    isTogglable: false,
                  ),
                  SettingButton(
                    icon: FontAwesomeIcons.userCircle,
                    text: 'User Details',
                    isSelected: false,
                    isTogglable: false,
                  ),
                  SettingButton(
                    icon: FontAwesomeIcons.info,
                    text: 'About',
                    isSelected: false,
                    isTogglable: false,
                  ),
                  SettingButton(
                    icon: FontAwesomeIcons.signOutAlt,
                    text: 'Logout',
                    isSelected: false,
                    isTogglable: false,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
