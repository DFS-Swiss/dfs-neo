import 'package:flutter/material.dart';

class CustomProgressIndicator extends StatelessWidget {
  final bool triggered;
  const CustomProgressIndicator({
    Key? key,
    required this.triggered,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 400),
        width: triggered ? 40 : 10,
        height: 10,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: triggered
                ? Color(0xff31BFD5).withOpacity(1)
                : Color.fromARGB(255, 99, 163, 173).withOpacity(0.45)),
      ),
    );
  }
}
