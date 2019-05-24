import 'package:flutter/material.dart';

class MenuButton extends StatefulWidget {
  final BuildContext context;
  final EdgeInsets margin;
  final Function onToggled;
  final bool value;
  final double radius;
  final Color firstColor;
  final Color secondColor;

  const MenuButton(
      {Key key,
      this.context,
      this.margin,
      @required this.onToggled,
      @required this.radius,
      this.firstColor,
      this.secondColor, this.value})
      : assert(radius != 0, 'radius value shouldn\'t be zero');
  @override
  MenuButtonState createState() => MenuButtonState();
}

class MenuButtonState extends State<MenuButton> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onToggled,
      child: Container(
        padding: EdgeInsets.all(16.0),
        margin: widget.margin,
        color: Colors.transparent,
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: CircleAvatar(
                      radius: widget.radius,
                      backgroundColor: widget.secondColor,
                    ),
                  ),
                  CircleAvatar(
                    radius: widget.radius,
                    backgroundColor: widget.value ?  Colors.blue : widget.firstColor
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: CircleAvatar(
                      radius: widget.radius,
                      backgroundColor: widget.secondColor,
                    ),
                  ),
                  CircleAvatar(
                    radius: widget.radius,
                    backgroundColor: widget.secondColor,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
