import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/formatting_service.dart';

import '../development_indicator/detailed_development_indicator.dart';

class AssetDevelopmentCard extends HookWidget {
  final String name;
  final double changePercentage;
  final double changeValue;
  const AssetDevelopmentCard({
    Key? key,
    required this.name,
    required this.changePercentage,
    required this.changeValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 63,
      padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            name,
            style: GoogleFonts.urbanist(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          DetailedDevelopmentIndicator(
            positive: !changePercentage.isNegative,
            changePercentage:
                FormattingService.roundDouble(changePercentage, 2),
            changeValue: FormattingService.roundDouble(changeValue, 2),
          )
        ],
      ),
    );
  }
}
