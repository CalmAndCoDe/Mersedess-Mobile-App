import 'package:flutter/material.dart';
import 'package:mobile_app/Elements/MenuButton.dart';
import 'package:mobile_app/Elements/UserProfile.dart';
import 'package:mobile_app/Views/ProfileSettings.dart';

class CustomAppBar {
  var _toggled = ValueNotifier(false);
  AnimationController _menuController;

  set menuController(AnimationController _controller) {
    _menuController = _controller;
  }

  get menuState => _toggled;

  appBar(BuildContext context) {
    return PreferredSize(
      preferredSize: Size(MediaQuery.of(context).size.width, 80),
      child: Container(
          constraints: BoxConstraints.expand(),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(79),
            ),
          ),
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                ValueListenableBuilder(
                  valueListenable: _toggled,
                  builder: (context, value, child) {
                    return MenuButton(
                      context: context,
                      margin: EdgeInsets.only(left: 16.0),
                      radius: 6.0,
                      firstColor: Theme.of(context).textTheme.body2.color,
                      secondColor: Theme.of(context).textTheme.body1.color.withOpacity(.8),
                      onToggled: () {
                        _toggled.value
                            ? _menuController.reverse().orCancel
                            : _menuController.forward().orCancel;
                        _toggled.value = !_toggled.value;
                      },
                      value: _toggled.value,
                    );
                  },
                ),
                UserProfile(
                  context: context,
                  margin: EdgeInsets.only(right: 0.0),
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ProfileSettings())),
                )
              ],
            ),
          )),
    );
  }

  CustomAppBar();

  static final _getInstance = CustomAppBar();
  factory CustomAppBar.getInstance() {
    return _getInstance;
  }
}
