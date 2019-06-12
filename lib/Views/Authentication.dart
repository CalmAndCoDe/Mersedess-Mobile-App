import 'package:flutter/material.dart';
import 'package:mobile_app/Elements/SettingButton.dart';
import 'package:mobile_app/Functions/TextStyles.dart';

class AuthenticationSettings extends StatefulWidget {
  @override
  _AuthenticationSettingsState createState() => _AuthenticationSettingsState();
}

class _AuthenticationSettingsState extends State<AuthenticationSettings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Material(
        color: Theme.of(context).backgroundColor,
        child: Container(
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
                          'Authentication Settings',
                          style: settingButtonStyle,
                        )
                      ],
                    ),
                  ),
                ),
                Flexible(
                  flex: 20,
                  child: Column(
                    children: <Widget>[
                      SettingButton(
                        icon: Icons.fingerprint,
                        text: 'Fingerprint',
                        isSelected: false,
                        isTogglable: true,
                        onTap: () => {print('tapped')},
                      ),
                      SettingButton(
                        icon: Icons.lock_outline,
                        text: 'Passcode',
                        isSelected: false,
                        isTogglable: true,
                        onTap: () => {print('tapped')},
                      ),
                      Text(
                        'Set Up',
                        style: settingButtonStyle.copyWith(
                            color: Theme.of(context).textTheme.body2.color),
                        textAlign: TextAlign.end,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
