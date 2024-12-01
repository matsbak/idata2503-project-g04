import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class RatingLineChart extends StatefulWidget {
  const RatingLineChart({super.key});

  @override
  State<RatingLineChart> createState() => _RatingLineChartState();
}

class _RatingLineChartState extends State<RatingLineChart> {
  List<Color> gradientColors = [
    const Color(0xFF582A72),
    const Color.fromARGB(255, 197, 165, 216),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Chart Title
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'User Rating Distribution',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Add overall padding
            child: LineChart(
              mainData(),
            ),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
      color: Colors.white,
    );
    String text = value.toStringAsFixed(1); // Map 0.5, 1.0, ...
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: Text(text, style: style),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 12,
      color: Colors.white,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: Text(value.toInt().toString(), style: style),
    );
  }

  LineChartData mainData() {
    final spots = [
      FlSpot(0.5, 1), // 1 review for 0.5 rating
      FlSpot(1.0, 1), // 2 reviews for 1.0 rating
      FlSpot(1.5, 2),
      FlSpot(2.0, 3),
      FlSpot(2.5, 3),
      FlSpot(3.0, 4),
      FlSpot(3.5, 3),
      FlSpot(4.0, 5),
      FlSpot(4.5, 3),
      FlSpot(5.0, 4), // 6 reviews for 5.0 rating
    ];

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 25,
            interval: 0.5,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 15,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0.5,
      maxX: 5.0,
      minY: 0,
      maxY: 6, // Adjust based on highest review count
      lineBarsData: [
        LineChartBarData(
          spots: spots, // Data points
          isCurved: true, // Smooth lines
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: true,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }
}
