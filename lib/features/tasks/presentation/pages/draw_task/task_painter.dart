import 'dart:ui';

import 'package:flutter/material.dart';

class TaskPainter extends CustomPainter {
  final List<Offset> offsets;
  final Color strokeColor;
  TaskPainter({
    @required this.offsets,
    this.strokeColor,
  }) : super();

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = strokeColor
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    for (int i = 0; i < offsets.length - 1; i++) {
      if (offsets[i] != null && offsets[i + 1] != null) {
        final p1 = offsets[i];
        final p2 = offsets[i + 1];
        canvas.drawLine(p1, p2, paint);
      }
      if (offsets[i] != null && offsets[i + 1] == null) {
        canvas.drawPoints(PointMode.points, [offsets[i]], paint);
      }
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
