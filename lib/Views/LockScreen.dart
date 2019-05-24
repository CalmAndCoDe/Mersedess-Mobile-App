import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/Bloc/Authentication.dart';

class LockScreen extends StatefulWidget {
  @override
  _LockScreenState createState() => _LockScreenState();
}

class _LockScreenState extends State<LockScreen>
    with SingleTickerProviderStateMixin {
  var authentication = Authentication.instance();
  var startPoint;
  var currentPoint = 0.5;
  var distance;
  AnimationController _animationController;
  Animation<double> _animation;
  bool animated = false;
  bool readyRevers = false;
  bool lockDown = false;

  @override
  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {
              currentPoint = _animation.value;
            });
            if (_animationController.isCompleted) {
              lockDown = true;
              print('locked');
            }
          });
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FractionallySizedBox(
      heightFactor: currentPoint,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).textTheme.body2.color.withOpacity(.8)
              ],
              begin: FractionalOffset(-0.5, -0.5),
              end: FractionalOffset(1.0, 1.0)),
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(99),
          ),
        ),
        child: GestureDetector(
          dragStartBehavior: DragStartBehavior.down,
          behavior: HitTestBehavior.deferToChild,
          onVerticalDragStart: _panStart,
          onVerticalDragUpdate: _panUpdate,
          onVerticalDragEnd: _panEnd,
          child: Stack(
            children: <Widget>[
              Container(
                margin: EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Text(
                        'Locked',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 48,
                            fontFamily: 'Great Vibes'),
                      ),
                      Text(
                        'Slide down to unlock',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontFamily: 'Open Sans Condensed',
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  void _panStart(DragStartDetails details) {}

  void _panUpdate(DragUpdateDetails details) {
    setState(() {
      var point = details.globalPosition.dy;
        currentPoint = ((point) / 1000 * 1.8).clamp(0.5, 1.0);
    });
    if (currentPoint > 0.8 && !animated && !readyRevers) {
      _animationController.forward().orCancel;
      _animation = Tween<double>(begin: currentPoint, end: 1.0).animate(
          CurvedAnimation(curve: Curves.ease, parent: _animationController));
      animated = true;
      readyRevers = true;
    } else if (currentPoint <= 0.8 && readyRevers && animated) {
      _animationController.reverse().orCancel;
      _animation = Tween<double>(begin: 0.5, end: currentPoint).animate(
          CurvedAnimation(curve: Curves.easeOut, parent: _animationController));
      animated = true;
      readyRevers = false;
    }
  }

  void _panEnd(DragEndDetails details) {
    animated = false;
    readyRevers = false;
    lockDown = false;
    if (_animationController.isCompleted) {
      _animationController.reset();
    }
  }
}
