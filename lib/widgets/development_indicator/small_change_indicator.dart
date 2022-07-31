import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:neo/style/theme.dart';
import 'package:neo/widgets/hideable_text.dart';

class SmallDevelopmentIndicator extends StatelessWidget {
  const SmallDevelopmentIndicator({
    Key? key,
    required this.positive,
    required this.changePercentage,
    this.isInPercent = true,
    this.hideable = false,
  }) : super(key: key);

  final bool positive;
  final double changePercentage;
  final bool isInPercent;
  final bool hideable;

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
        !hideable
            ? Text(
                isInPercent
                    ? "${NumberFormat.compact().format(changePercentage)}%"
                    : NumberFormat.compact().format(changePercentage),
                style: TextStyle(
                  fontSize: 12,
                  color: positive
                      ? NeoTheme.of(context)!.positiveColor
                      : NeoTheme.of(context)!.negativeColor,
                  fontWeight: FontWeight.w400,
                ),
              )
            : HideableText(
                isInPercent
                    ? "${NumberFormat.compact().format(changePercentage)}%"
                    : NumberFormat.compact().format(changePercentage),
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
