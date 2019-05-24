import 'package:flutter/material.dart';

class CustomMenuItem extends StatelessWidget {
  final Color backgroundColor;
  final Color itemColor;
  final Function onTap;
  final Widget child;
  final isSelected;
  final isMenuButton;

  const CustomMenuItem(
      {Key key,
      this.backgroundColor,
      @required this.itemColor,
      this.onTap,
      @required this.child, this.isSelected = false, this.isMenuButton = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      child: ClipOval(
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Container(
              height: 50,
              width: 50,
              color: isMenuButton ? Colors.transparent : isSelected && !isMenuButton ? Theme.of(context).primaryColor : Theme.of(context).primaryColor.withOpacity(.2),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
