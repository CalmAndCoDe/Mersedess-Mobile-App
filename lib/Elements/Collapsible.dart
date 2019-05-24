import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Collapsible extends StatelessWidget {
  final startPoint;
  var currentPoint = 0.5;
  final AnimationController animationController;
  Animation<double> _animation;
  bool animated = false;
  bool readyRevers = false;
  bool lockDown = false;
  final Widget child;
  final GlobalKey context;

  Collapsible({
    this.context,
    Key key,
    this.animationController,
    this.startPoint,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        dragStartBehavior: DragStartBehavior.down,
        onVerticalDragStart: _panStart,
        onVerticalDragUpdate: _panUpdate,
        onVerticalDragEnd: _panEnd,
        child: FractionallySizedBox(
          heightFactor: currentPoint,
          child: child,
        ));
  }

  void _panStart(DragStartDetails details) {}

  void _panUpdate(DragUpdateDetails details) {
    context.currentState.setState(() {
      var point = details.globalPosition.dy;
      if (!lockDown) {
        currentPoint = ((point) / 1000 * 1.8).clamp(0.5, 1.0);
      }
    });
    if (currentPoint > 0.8 && !animated && !readyRevers) {
      animationController.forward().orCancel;
      _animation = Tween<double>(begin: currentPoint, end: 1.0).animate(
          CurvedAnimation(curve: Curves.ease, parent: animationController));
      animated = true;
      readyRevers = true;
    } else if (currentPoint < 0.8 && readyRevers && animated) {
      animationController.reverse().orCancel;
      _animation = Tween<double>(begin: 0.5, end: currentPoint).animate(
          CurvedAnimation(curve: Curves.easeOut, parent: animationController));
      animated = true;
      readyRevers = false;
    }
  }

  void _panEnd(DragEndDetails details) {
    animated = false;
    readyRevers = false;
    lockDown = false;
    if (animationController.isCompleted) {
      animationController.reset();
    }
  }
}
