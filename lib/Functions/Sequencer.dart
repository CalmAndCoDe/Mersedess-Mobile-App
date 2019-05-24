import 'package:flutter/material.dart';
import 'package:flutter/animation.dart';

sequencer(AnimationController _controller, double _start, double _end,
      Curve _curve) {
    return Tween<Offset>(begin: Offset(0.0, 10.0), end: Offset(0.0, 0.0))
        .animate(CurvedAnimation(
            curve: Interval(_start, _end, curve: _curve), parent: _controller));
  }