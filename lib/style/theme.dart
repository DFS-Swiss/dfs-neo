import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NeoTheme extends InheritedWidget {
  NeoTheme({super.key, required super.child}) : super();

  final LinearGradient primaryGradient = const LinearGradient(colors: [
    Color.fromRGBO(49, 191, 212, 1),
    Color.fromRGBO(32, 209, 209, 1)
  ]);
  final Color primaryColor = Color.fromRGBO(49, 191, 212, 1);
  final Color positiveColor = const Color.fromRGBO(101, 195, 136, 1);
  final Color negativeColor = const Color.fromRGBO(255, 125, 148, 1);
  final TextStyle linkTextStyle = GoogleFonts.urbanist(
    color: Color(0xFF05889C),
    fontSize: 15,
    fontWeight: FontWeight.w600,
    decoration: TextDecoration.underline,
  );
  final BorderRadius primaryBorderRadius = BorderRadius.circular(12);
  final double secondaryBorderRadius = 30;

  static NeoTheme? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<NeoTheme>();
  }

  @override
  bool updateShouldNotify(NeoTheme oldWidget) {
    return true;
  }
}
