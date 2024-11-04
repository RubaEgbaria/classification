import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class LineChartSample extends StatelessWidget {
  final String eq;
  final List<double>? xValues;
  final List<double>? yValues;
  final List<int>? yDesired;
  final int? classId;

  LineChartSample({
    super.key,
    required this.eq,
    this.xValues,
    this.yValues,
    this.yDesired,
    this.classId,
  }) {
    minSpotX = xValues != null ? xValues!.reduce((a, b) => a < b ? a : b) : 0;
    maxSpotX = xValues != null ? xValues!.reduce((a, b) => a > b ? a : b) : 0;
    minSpotY = yValues != null ? yValues!.reduce((a, b) => a < b ? a : b) : 0;
    maxSpotY = yValues != null ? yValues!.reduce((a, b) => a > b ? a : b) : 0;

    final parsedEquation = parseEquation(eq);
    if (parsedEquation != null) {
      final w0 = parsedEquation[0];
      final w1 = parsedEquation[1];

      spots = generateEquationSpots(w0, w1, minSpotX, maxSpotX, 10);
    } else {
      spots = [];
    }

    scatterSpots = generateScatterSpots(xValues, yValues);
  }

  late List<FlSpot> spots;
  late double minSpotX;
  late double maxSpotX;
  late double minSpotY;
  late double maxSpotY;
  late List<FlSpot> scatterSpots;

  List<double>? parseEquation(String equation) {
    // Example: "y = -0.01 * x + 0.5"
    RegExp regExp = RegExp(r'y\s*=\s*([-\d.]+)\s*\*\s*x\s*\+\s*([-\d.]+)');
    Match? match = regExp.firstMatch(equation);
    if (match != null) {
      double slope = double.parse(match.group(1)!);
      double intercept = double.parse(match.group(2)!);
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
  // spots that belong to current class (classID)

  List<FlSpot> generateCurrentClassSpot() {
    List<FlSpot> spots = [];
    for (int i = 0; i < xValues!.length; i++) {
      if (yDesired![i] == classId) {
        spots.add(FlSpot(xValues![i], yValues![i]));
      }
    }
    return spots;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: AspectRatio(
        aspectRatio: 3,
        child: LineChart(
          LineChartData(
            lineBarsData: [
              LineChartBarData(
                spots: scatterSpots,
                color: Colors.red,
                barWidth: 0,
              ),
              LineChartBarData(
                barWidth: 2,
                isStrokeCapRound: true,
                gradient: const LinearGradient(
                    colors: [Colors.blueGrey, Colors.lightBlueAccent]),
                spots: spots,
              ),
              LineChartBarData(
                spots: generateCurrentClassSpot(),
                color: Colors.purpleAccent,
                barWidth: 0,
              ),
            ],
            minY: minSpotY,
            maxY: maxSpotY,
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
