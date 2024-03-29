import 'package:flutter/material.dart';
import 'package:neo/style/theme.dart';

class DetailedDevelopmentIndicator extends StatelessWidget {
  const DetailedDevelopmentIndicator({
    Key? key,
    required this.positive,
    required this.changePercentage,
    required this.changeValue,
    this.fontSize = 12,
    this.iconSize = 25,
  }) : super(key: key);

  final bool positive;
  final double changePercentage;
  final double changeValue;
  final double fontSize;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          positive
              ? Icons.arrow_drop_up_outlined
              : Icons.arrow_drop_down_outlined,
          size: iconSize,
          color: positive
              ? NeoTheme.of(context)!.positiveColor
              : NeoTheme.of(context)!.negativeColor,
        ),
        Text(
          "$changeValue d\$ ($changePercentage %)",
          style: TextStyle(
            fontSize: fontSize,
            color: positive
                ? NeoTheme.of(context)!.positiveColor
                : NeoTheme.of(context)!.negativeColor,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}
