import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final double height;
  final double width;
  final Widget child;
  final Function onTap;

  const Button({Key key, this.height, this.width, this.child, @required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
          child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).textTheme.body2.color,
        ),
        height: height,
        width: width,
        child: Center(
          child: InkWell(
            onTap: onTap,
            child: child,
          ),
        ),
      ),
    );
  }
}
