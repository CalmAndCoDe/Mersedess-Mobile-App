import 'package:flutter/material.dart';

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
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.circular(12)),
            child: InkWell(
              onTap: onTap,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(
                      text,
                      style: TextStyle(
                          fontFamily: 'Open Sans Condensed',
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  isTogglable
                      ? Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Text(
                            isSelected ? 'ON' : 'OFF',
                            style: TextStyle(
                                fontFamily: 'Open Sans Condensed',
                                color:
                                    Theme.of(context).textTheme.body2.color,
                                fontWeight: FontWeight.bold),
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
