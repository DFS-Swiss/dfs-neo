import 'package:flutter/material.dart';

class NeoTheme extends InheritedWidget {
  NeoTheme({super.key, required super.child}) : super();

  final LinearGradient primaryGradient = const LinearGradient(colors: [
    Color.fromRGBO(49, 191, 212, 1),
    Color.fromRGBO(32, 209, 209, 1)
  ]);
  final Color positiveColor = const Color.fromRGBO(101, 195, 136, 1);
  final Color negativeColor = const Color.fromRGBO(255, 125, 148, 1);
  final TextStyle linkTextStyle = const TextStyle(
    color: Color(0x05889CFF),
    fontFamily: "Urbanist",
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 14.4,
    decoration: TextDecoration.underline,
  );
  final BorderRadius primaryBorderRadius = BorderRadius.circular(12);

  static NeoTheme? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<NeoTheme>();
  }

  @override
  bool updateShouldNotify(NeoTheme oldWidget) {
    return true;
  }
}
