import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:neo/style/theme.dart';

class SmallDevelopmentIndicator extends StatelessWidget {
  const SmallDevelopmentIndicator({
    Key? key,
    required this.positive,
    required this.changePercentage,
  }) : super(key: key);

  final bool positive;
  final double changePercentage;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          positive
              ? Icons.arrow_drop_up_outlined
              : Icons.arrow_drop_down_outlined,
          size: 25,
          color: positive
              ? NeoTheme.of(context)!.positiveColor
              : NeoTheme.of(context)!.negativeColor,
        ),
        Text(
          "${NumberFormat.compact().format(changePercentage)}%",
          style: TextStyle(
            fontSize: 12,
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
