import 'package:flutter/material.dart';



class RoundBox extends StatelessWidget {
  const RoundBox({
    Key key,
    @required this.isSelected,
    @required this.color,
    @required this.tickColor,
    @required this.onTap,
    @required this.margin,
  }) : super(key: key);

  final bool isSelected;
  final Color color;
  final Color tickColor;
  final Function onTap;
  final EdgeInsets margin;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: margin,
        height: 20,
        width: 20,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        child: Center(
          child: isSelected
              ? Icon(
                  Icons.check,
                  color: tickColor,
                  size: 20,
                )
              : Icon(
                  Icons.check_box_outline_blank,
                  color: tickColor,
                  size: 0,
                ),
        ),
      ),
    );
  }
}
