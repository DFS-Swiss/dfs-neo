import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'dart:ui' as ui;

import 'package:neo/pages/tutorial/blurecircle_widget.dart';

class BackgroundGraphic extends HookWidget {
  const BackgroundGraphic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Stack(
        children: [
          BlurCircle(
            alignment: Alignment(-2.9, 0.2),
          ),
          BlurCircle(
            alignment: Alignment(2.5, 1.3),
          ),
          CustomPaint(
            size: Size(
                MediaQuery.of(context).size.width,
                (MediaQuery.of(context).size.width * 1.12)
                    .toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
            painter: RPSCustomPainter(),
          ),
        ],
      ),
    );
  }
}

//Add this CustomPaint widget to the Widget Tree

//Copy this CustomPainter code to the Bottom of the File
class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0_fill = Paint()..style = PaintingStyle.fill;
    paint_0_fill.shader = ui.Gradient.linear(
        Offset(size.width * -46.93333, size.height),
        Offset(size.width * 1.332872, size.height * 0.8073690), [
      const Color(0xff31BFD5).withOpacity(1),
      const Color(0xff20D1D1).withOpacity(0.35)
    ], [
      0,
      1
    ]);
    canvas.drawCircle(Offset(size.width * 0.3106667, size.height * 0.3035714),
        size.width * 0.7800000, paint_0_fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
