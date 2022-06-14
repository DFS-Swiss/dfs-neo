import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

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

LineChartData details(List<FlSpot> data, bool isNegative) {
  return LineChartData(
    gridData: FlGridData(
      show: true,
      drawVerticalLine: false,
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: const Color(0xff37434d).withOpacity(0.5),
          strokeWidth: 1,
        );
      },
      getDrawingVerticalLine: (value) {
        return FlLine(
          color: const Color(0xff37434d),
          strokeWidth: 1,
        );
      },
    ),
    titlesData: FlTitlesData(
      show: true,
      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: false,
          interval: 5000,
          getTitlesWidget: bottomTileWidget,
        ),
      ),
    ),
    borderData: FlBorderData(
        show: false,
        border: Border.all(color: const Color(0xff37434d), width: 1)),
    //minX: 0,
    //maxX: 11,
    //maxY: 6,
    lineBarsData: [
      LineChartBarData(
        spots: data,
        isCurved: false,
        color: isNegative ? Colors.red : Colors.green,
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: false,
          gradient: LinearGradient(colors: gradientColors),
        ),
      ),
    ],
  );
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
