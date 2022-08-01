import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class CustomDotPainter extends FlDotPainter {
  @override
  void draw(Canvas canvas, FlSpot spot, Offset offsetInCanvas) {
    Paint paint1 = Paint();
    paint1.color = Color(0xFF1C9AC2).withOpacity(0.2);

    Paint paint2 = Paint();
    paint2.color = Color(0xFF1C9AC2);

    Paint paint3 = Paint();
    paint3.color = Colors.white;

    Paint linePaint = Paint();
    linePaint.color = Colors.grey;

    //canvas.drawLine(p1, Offset(offsetInCanvas.dx, this.), linePaint);

    canvas.drawCircle(offsetInCanvas, 9, paint1);
    canvas.drawCircle(offsetInCanvas, 5, paint2);
    canvas.drawCircle(offsetInCanvas, 2, paint3);
  }

  @override
  Size getSize(FlSpot spot) {
    return Size(0, 0);
  }

  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}
