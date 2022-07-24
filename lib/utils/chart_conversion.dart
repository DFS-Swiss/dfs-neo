import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:neo/service_locator.dart';
import 'package:neo/services/chart_scrubbing_manager.dart';
import 'package:neo/services/formatting_service.dart';
import 'package:neo/types/chart_scrubbing_state.dart';
import 'package:neo/utils/custom_dot_painter.dart';

List<Color> gradientColors = [
  const Color(0xff23b6e6),
  const Color(0xff02d39a),
];

List<Color> bottomgradientColors = [
  const Color(0xff23b6e6),
  Color.fromRGBO(2, 211, 154, 1),
];

Widget bottomTileWidget(double value, TitleMeta meta) {
  return SideTitleWidget(
    axisSide: meta.axisSide,
    space: 8.0,
    child: Text(
        DateTime.fromMillisecondsSinceEpoch(value.toInt() * 1000).toString()),
  );
}

Widget leftTileWidget(double value, TitleMeta meta) {
  return SideTitleWidget(
    axisSide: meta.axisSide,
    space: 8.0,
    child: Text(FormattingService.roundDouble(value, 0).round().toString()),
  );
}

LineChartData details(List<FlSpot> data, bool isNegative) {
  return LineChartData(
    lineTouchData: LineTouchData(touchTooltipData:
        LineTouchTooltipData(getTooltipItems: (touchedBarSpots) {
      return touchedBarSpots.map((barSpot) {
        return null;
      }).toList();
    }), touchCallback: (event, res) {
      if (event is FlTapUpEvent ||
          event is FlLongPressEnd ||
          event is FlPanEndEvent) {
        locator<ChartSrubbingManager>()
            .setState(ChartScrubbingState(false, 0, 0));
        return;
      }
      if (res != null) {
        locator<ChartSrubbingManager>().setState(ChartScrubbingState(
            true, res.lineBarSpots![0].x, res.lineBarSpots![0].y));
      }
    }, getTouchedSpotIndicator: (line, indizes) {
      return indizes
          .map(
            (e) => TouchedSpotIndicatorData(
              FlLine(color: Colors.transparent),
              FlDotData(
                getDotPainter: (p0, p1, p2, p3) => CustomDotPainter(),
              ),
            ),
          )
          .toList();
    }),
    gridData: FlGridData(
      show: false,
    ),
    titlesData: FlTitlesData(
      show: false,
    ),
    borderData: FlBorderData(
      show: false,
    ),
    lineBarsData: [
      LineChartBarData(
        spots: data,
        isCurved: false,
        gradient: !isNegative
            ? LinearGradient(colors: const [
                Color(0xFF58E9D7),
                Color(0xFF0EB9C2),
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter)
            : LinearGradient(
                colors: const [Color(0xFFFF7D94), Color(0xFFF33556)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
        barWidth: 1.7,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          gradient: !isNegative
              ? LinearGradient(colors: [
                  Color(0xFF0EB9C2).withOpacity(0.2),
                  Color(0xFF58E9D7).withOpacity(0),
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter)
              : LinearGradient(
                  colors: [
                    Color(0xFFF33556).withOpacity(0.2),
                    Color(0xFFFF7D94).withOpacity(0.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
        ),
      ),
    ],
  );
}

double findInterval(List<FlSpot> data) {
  var min = getMin(data);
  var max = getMax(data);

  return (max - min) / 7;
}

double getMax(List<FlSpot> data) {
  double max = 0;
  for (var element in data) {
    if (element.y > max) {
      max = element.y;
    }
  }
  return max;
}

double getMin(List<FlSpot> data) {
  double min = double.maxFinite;
  for (var element in data) {
    if (element.y < min) {
      min = element.y;
    }
  }
  return min;
}

LineChartData preview(List<FlSpot> data, bool isNegative) {
  return LineChartData(
    gridData: FlGridData(show: false),
    titlesData: FlTitlesData(
      show: false,
      rightTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      topTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
    ),
    borderData: FlBorderData(
        show: false,
        border: Border.all(color: const Color(0xff37434d), width: 1)),
    lineBarsData: [
      LineChartBarData(
        spots: data,
        isCurved: false,
        gradient: !isNegative
            ? LinearGradient(colors: const [
                Color(0xFF58E9D7),
                Color(0xFF0EB9C2),
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter)
            : LinearGradient(
                colors: const [Color(0xFFFF7D94), Color(0xFFF33556)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
        barWidth: 1.5,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
      ),
    ],
  );
}

LineChartData dashboardPortfolio(List<FlSpot> data, bool isNegative) {
  return LineChartData(
    gridData: FlGridData(show: false),
    titlesData: FlTitlesData(
      show: false,
      rightTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      topTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
    ),
    borderData: FlBorderData(
        show: false,
        border: Border.all(color: const Color(0xff37434d), width: 1)),
    lineBarsData: [
      LineChartBarData(
        spots: data,
        isCurved: false,
        gradient: !isNegative
            ? LinearGradient(colors: const [
                Color(0xFF58E9D7),
                Color(0xFF0EB9C2),
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter)
            : LinearGradient(
                colors: const [Color(0xFFFF7D94), Color(0xFFF33556)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter),
        barWidth: 1.7,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: true,
          gradient: !isNegative
              ? LinearGradient(colors: [
                  Color(0xFF0EB9C2).withOpacity(0.2),
                  Color(0xFF58E9D7).withOpacity(0),
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter)
              : LinearGradient(
                  colors: [
                    Color(0xFFF33556).withOpacity(0.2),
                    Color(0xFFFF7D94).withOpacity(0.0),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
        ),
      ),
    ],
  );
}
