import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';

// ignore: must_be_immutable
class LineChartSample extends StatelessWidget {
  final String? equation1;
  final String? equation2;

// try to print the dots on the graph
  LineChartSample({
    super.key,
    Color? line1Color1,
    Color? line1Color2,
    Color? line2Color1,
    Color? line2Color2,
    this.equation1,
    this.equation2,
  })  : line1Color1 = line1Color1 ?? Colors.blueGrey,
        line1Color2 = line1Color2 ?? Colors.grey,
        line2Color1 = line2Color1 ?? Colors.accents.first,
        line2Color2 = line2Color2 ?? Colors.accents.first {
    minSpotX = -9;
    maxSpotX = 0;
    minSpotY = -9;
    maxSpotY = 0;

    spots = equation1 != null
        ? generateEquationSpots(equation1!, minSpotX, maxSpotX, 1)
        : [];
    spots2 = equation2 != null
        ? generateEquationSpots(equation2!, minSpotX, maxSpotX, 1)
        : [];

    // Calculate min and max Y values from the generated spots
    if (spots.isNotEmpty) {
      minSpotY = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
      maxSpotY = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    }

    if (spots2.isNotEmpty) {
      double minY2 = spots2.map((s) => s.y).reduce((a, b) => a < b ? a : b);
      double maxY2 = spots2.map((s) => s.y).reduce((a, b) => a > b ? a : b);
      minSpotY = minSpotY < minY2 ? minSpotY : minY2;
      maxSpotY = maxSpotY > maxY2 ? maxSpotY : maxY2;
    }
  }

  final Color line1Color1;
  final Color line1Color2;
  final Color line2Color1;
  final Color line2Color2;

  late List<FlSpot> spots;
  late List<FlSpot> spots2;

  late double minSpotX;
  late double maxSpotX;
  late double minSpotY;
  late double maxSpotY;

  List<FlSpot> generateEquationSpots(
      String equation, double minX, double maxX, int numPoints) {
    List<FlSpot> spots = [];
    for (int i = 0; i <= numPoints; i++) {
      double x = minX + (i * (maxX - minX) / numPoints);
      dynamic y = evaluateEquation(equation, x);
      spots.add(FlSpot(x, y));
    }
    return spots;
  }

  double evaluateEquation(String equation, double x) {
    print('Evaluating equation: $equation with x = $x');

    try {
      final expression = Expression.parse(equation);
      const evaluator = ExpressionEvaluator();
      final result = evaluator.eval(expression, {'X': x});
      return result as double;
    } catch (e) {
      return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: AspectRatio(
        aspectRatio: 2,
        child: LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                gradient: LinearGradient(colors: [line1Color1, line1Color2]),
                spots: spots,
                isCurved: true,
                barWidth: 5,
              ),
              LineChartBarData(
                gradient: LinearGradient(colors: [line2Color1, line1Color2]),
                spots: spots2,
                isCurved: true,
                barWidth: 5,
              ),
            ],
            minY: minSpotY,
            maxY: maxSpotY,
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 38,
                      getTitlesWidget: (value, meta) {
                        return Text(value.toString(),
                            style: const TextStyle(fontSize: 10));
                      })),
              bottomTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: true),
              ),
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            gridData: const FlGridData(show: true, drawVerticalLine: true),
            borderData: FlBorderData(
              show: true,
              border: const Border(
                left: BorderSide(color: Colors.black),
                top: BorderSide(color: Colors.transparent),
                bottom: BorderSide(color: Colors.transparent),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
