import 'package:flutter/material.dart';
import 'package:mobile_app/Functions/TextStyles.dart';

class SettingButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final Function onTap;
  final isSelected;
  final isTogglable;

  const SettingButton(
      {Key key,
      this.icon,
      this.text,
      this.onTap,
      this.isSelected = false,
      this.isTogglable = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 44,
            width: 44,
            margin: EdgeInsets.only(right: 8.0),
            decoration: BoxDecoration(
                color: Theme.of(context).textTheme.body2.color,
                borderRadius: BorderRadius.circular(12)),
            child: InkWell(
              enableFeedback: true,
              borderRadius: BorderRadius.circular(12),
              onTap: onTap,
              child: Icon(
                icon,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Container(
            height: 44,
            width: MediaQuery.of(context).size.width * .70,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(.8),
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              enableFeedback: true,
              borderRadius: BorderRadius.circular(12),
              onTap: onTap,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(
                      text,
                      style: settingButtonStyle,
                    ),
                  ),
                  isTogglable
                      ? Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Text(
                            isSelected ? 'ON' : 'OFF',
                            style: settingButtonStyle.copyWith(
                              color: Theme.of(context).textTheme.body2.color
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
