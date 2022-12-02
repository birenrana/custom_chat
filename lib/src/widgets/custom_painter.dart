import 'package:flutter/material.dart';

class CustomShape extends CustomPainter {
  final Color bgColor;

  CustomShape(this.bgColor);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = bgColor;

    var path = Path();
    path.lineTo(-5, 0);
    path.lineTo(0, 10);
    path.lineTo(5, 0);

    // path.lineTo(0, 10);
    // path.lineTo(-10, 0);
    // path.lineTo(0, -10);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class CustomReverseShape extends CustomPainter {
  final Color bgColor;

  CustomReverseShape(this.bgColor);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = bgColor;

    var path = Path();

    // path.lineTo(0, -15);
    // path.lineTo(-15, 0); fish
    // path.lineTo(15, 15);

    path.lineTo(0, 10);
    path.lineTo(-10, 0);
    // path.lineTo(0, -5);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}

class CustomLeftReverseShape extends CustomPainter {
  final Color bgColor;

  CustomLeftReverseShape(this.bgColor);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = bgColor;

    var path = Path();

    path.lineTo(0, 10);
    path.lineTo(-10, 0);
    path.lineTo(0, -10);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
