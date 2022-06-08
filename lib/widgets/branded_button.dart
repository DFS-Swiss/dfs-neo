import 'package:flutter/material.dart';
import 'package:neo/style/theme.dart';

class BrandedButton extends StatelessWidget {
  final String text;
  const BrandedButton({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44.0,
      decoration: BoxDecoration(
          gradient: NeoTheme.of(context)!.primaryGradient,
          borderRadius: NeoTheme.of(context)!.primaryBorderRadius),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
          shadowColor: Colors.transparent,
        ),
        child: Text(text),
      ),
    );
  }
}
