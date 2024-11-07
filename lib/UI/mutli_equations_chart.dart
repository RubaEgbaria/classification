import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MutliEquationsChart extends StatelessWidget {
  final List<String> equations;
  final List<double>? xValues;
  final List<double>? yValues;
  final List<int> yPred;

  MutliEquationsChart({
    super.key,
    required this.equations,
    this.xValues,
    this.yValues,
    required this.yPred,
  }) {
    minSpotX = xValues != null ? xValues!.reduce((a, b) => a < b ? a : b) : 0;
    maxSpotX = xValues != null ? xValues!.reduce((a, b) => a > b ? a : b) : 0;
    minSpotY = yValues != null ? yValues!.reduce((a, b) => a < b ? a : b) : 0;
    maxSpotY = yValues != null ? yValues!.reduce((a, b) => a > b ? a : b) : 0;

    for (final eq in equations) {
      final parsed = parseEquation(eq);
      if (parsed != null) {
        final w0 = parsed[0];
        final w1 = parsed[1];
        equationSpots
            .add(generateEquationSpots(w0, w1, minSpotX, maxSpotX, 10));
      }
    }
  }

  late List<FlSpot> scatterSpots;
  late double minSpotX;
  late double maxSpotX;
  late double minSpotY;
  late double maxSpotY;
  final List<List<FlSpot>> equationSpots = [];
  Map<int, List<FlSpot>> yPredSpots = {};

  List<double>? parseEquation(String equation) {
    // Example: "y = -0.01 * x + 0.5"
    RegExp regExp = RegExp(r'y\s*=\s*([-\d.]+)\s*\*\s*x\s*([+-]\s*[\d.]+)?');
    Match? match = regExp.firstMatch(equation);
    if (match != null) {
      double slope = double.parse(match.group(1)!);
      double intercept = double.parse(match.group(2)!.replaceAll(" ", ""));
      return [intercept, slope];
    }
    return null;
  }

  List<FlSpot> generateEquationSpots(
      double w0, double w1, double minX, double maxX, int numPoints) {
    List<FlSpot> spots = [];
    for (int i = 0; i <= numPoints; i++) {
      double x1 = minX + (maxX - minX) * i / numPoints;
      double y = w1 * x1 + w0; // y = mx + b
      spots.add(FlSpot(x1, y));
    }
    return spots;
  }

  List<FlSpot> generateScatterSpots(
      List<double>? xValues, List<double>? yValues) {
    if (xValues == null ||
        yValues == null ||
        xValues.length != yValues.length) {
      return [];
    }
    return List.generate(
        xValues.length, (index) => FlSpot(xValues[index], yValues[index]));
  }

  void generateYpredSpots(List<double> x1, List<double> x2, List<int> yPred) {
    Map<int, List<FlSpot>> classSpotsMap = {};

    for (int i = 0; i < x1.length; i++) {
      classSpotsMap.update(
        yPred[i],
        (value) => value..add(FlSpot(x1[i], x2[i])),
        ifAbsent: () => [FlSpot(x1[i], x2[i])],
      );
    }
    yPredSpots = classSpotsMap;

    print("yPredSpots: $yPredSpots");
  }

  @override
  Widget build(BuildContext context) {
    generateYpredSpots(xValues!, yValues!, yPred);

    print("y pred: $yPred");

    final Map<int, Color> classColors = {
      1: Colors.purple,
      2: Colors.orange,
      3: Colors.green,
      4: Colors.red
    };

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: AspectRatio(
        aspectRatio: 1.2,
        child: LineChart(
          LineChartData(
            lineBarsData: [
              for (final spots in yPredSpots.entries)
                LineChartBarData(
                  spots: spots.value,
                  isCurved: false,
                  isStrokeJoinRound: true,
                  color: classColors[spots.key],
                  barWidth: 0,
                ),
              for (final spots in equationSpots)
                LineChartBarData(
                  spots: spots,
                  color: Colors.blue,
                  barWidth: 2,
                ),
            ],
            titlesData: const FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 30,
                ),
              ),
              topTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
            ),
            gridData: const FlGridData(show: true, drawVerticalLine: true),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: const Color(0xff37434d), width: 1),
            ),
          ),
        ),
      ),
    );
  }
}
