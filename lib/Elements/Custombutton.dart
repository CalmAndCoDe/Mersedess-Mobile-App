import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Widget child;
  final Color color;
  final boxShadow;
  final height;
  final width;
  final int radius;
  const CustomButton({
    Key key,
    this.child,
    this.color,
    this.boxShadow,
    this.height = 60.0,
    this.width = 60.0,
    this.radius = 22
  }) : assert(height > 0.0 && width > 0.0);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints.loose(Size(height,width)),
      width: height ,
      height: width ,
      decoration: BoxDecoration(
        boxShadow: boxShadow,
        borderRadius: BorderRadius.circular(radius.toDouble()),
        color: color ?? Theme.of(context).textTheme.body2.color,
      ),
      child: Center(child: child),
    );
  }
}
