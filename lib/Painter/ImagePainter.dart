import 'package:flutter/material.dart';

class ImagePainter extends CustomPainter {
  final image;
  final double height;
  final double width;
  final xCoordinate;

  ImagePainter({this.xCoordinate = 0.0, this.height, this.width, this.image});


  @override
  void paint(Canvas canvas, Size size) {
    if (height >= size.height - 100) {
      canvas.drawImageRect(
          image,
          Rect.fromLTWH(
              ((size.width / 2) + (xCoordinate * 800.0)).clamp(0.0, (width / 2)),
              0,
              size.width,
              size.height),
          Rect.fromLTWH(0, 0, size.width, size.height),
          Paint()..color = Colors.blue);
    } else {
      canvas.drawImageRect(
          image,
          Rect.fromLTWH(0, 0, width, height),
          Rect.fromLTWH(0, 0, size.width, size.height),
          Paint()..color = Colors.blue);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return oldDelegate != this;
  }
}
