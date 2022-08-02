import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

final lightTheme = ThemeData(
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedIconTheme: IconThemeData(
      color: Color(0xFF05889C),
    ),
    selectedItemColor: Color(0xFF05889C),
  ),
  appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFFF8F9FB),
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(
        color: Colors.black,
        fontSize: 17,
        fontWeight: FontWeight.w600,
      )),
  textButtonTheme: TextButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all(
        Color(0xFF909090),
      ),
      overlayColor: MaterialStateProperty.all(Colors.grey[200]),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    ),
  ),
  progressIndicatorTheme: ProgressIndicatorThemeData(
    color: Colors.white,
  ),
  scaffoldBackgroundColor: Color(0xFFF8F9FB),
  backgroundColor: Colors.white,
  primaryColor: const Color.fromRGBO(32, 209, 209, 1),
  inputDecorationTheme: InputDecorationTheme(
    focusColor: Color.fromRGBO(32, 209, 209, 1),
    floatingLabelStyle: TextStyle(color: Color.fromRGBO(32, 209, 209, 1)),
    suffixIconColor: Colors.grey,
    hintStyle: TextStyle(
        color: Colors.grey.withOpacity(0.8), fontSize: 15, height: 2.2),
    focusedBorder: const UnderlineInputBorder(
      borderSide:
          const BorderSide(color: Color.fromRGBO(32, 209, 209, 1), width: 2.0),
    ),
  ),
  textTheme: GoogleFonts.urbanistTextTheme(
    TextTheme(
      titleSmall: TextStyle(
        color: Color.fromRGBO(187, 187, 187, 1),
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: TextStyle(
        color: Color(0xFF909090),
        fontWeight: FontWeight.w400,
        fontSize: 15,
      ),
      labelMedium: TextStyle(
          color: Color(0xFF202532), fontSize: 15, fontWeight: FontWeight.w600),
      bodySmall: TextStyle(
        color: Color.fromRGBO(144, 144, 144, 1),
        fontSize: 15,
        fontWeight: FontWeight.w500,
      ),
      bodyMedium: TextStyle(
        color: Color.fromRGBO(32, 37, 50, 1),
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      bodyLarge: TextStyle(
        color: Color.fromRGBO(32, 37, 50, 1),
        fontSize: 18,
        fontWeight: FontWeight.w500,
      ),
      headlineMedium: TextStyle(
        color: Color.fromRGBO(32, 37, 50, 1),
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
      headlineLarge: TextStyle(
        color: Color.fromRGBO(32, 37, 50, 1),
        fontSize: 22,
        fontWeight: FontWeight.w600,
      ),
    ),
  ),
);