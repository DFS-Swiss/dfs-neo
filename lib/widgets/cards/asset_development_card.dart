import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../services/formatting_service.dart';

import '../development_indicator/detailed_development_indicator.dart';

class AssetDevelopmentCard extends HookWidget {
  final String name;
  final List<FlSpot> chartData; 
  const AssetDevelopmentCard({
    Key? key,
    required this.name,
    required this.chartData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.75),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(width: 1, color: Colors.white),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            name,
            style: GoogleFonts.urbanist(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Expanded(
            child: Container(),
          ),
          DetailedDevelopmentIndicator(
            positive:
                chartData.first.y > chartData.last.y,
            changePercentage: FormattingService.calculatepercent(
                chartData.first.y, chartData.last.y),
            changeValue: FormattingService.roundDouble(
                chartData.first.y - chartData.last.y, 2),
          )
        ],
      ),
    );
  }
}
