import 'package:flutter/material.dart';

class BlurCircle extends StatelessWidget {
  final Alignment alignment;
  const BlurCircle({
    Key? key,
    required this.alignment,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(300),
          gradient: RadialGradient(
            colors: [
              const Color(0xff10DAD7).withOpacity(0.23),
              const Color(0xff10DAD7).withOpacity(0.2),
              const Color(0xff10DAD7).withOpacity(0.15),
              const Color(0xff10DAD7).withOpacity(0.1),
              const Color(0xff10DAD7).withOpacity(0.05),
              const Color(0xff10DAD7).withOpacity(0.01),
            ],
          ),
        ),
      ),
    );
  }
}
