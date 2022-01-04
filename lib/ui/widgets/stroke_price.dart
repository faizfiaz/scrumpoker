import 'package:flutter/material.dart';
import 'package:scrumpoker/constant/color.dart';

class StrokePrice extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const p1 = Offset(0, 20);
    const p2 = Offset(80, 0);
    final paint = Paint()
      ..color = greysLight
      ..strokeWidth = 1;
    canvas.drawLine(p1, p2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}
