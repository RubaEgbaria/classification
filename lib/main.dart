import 'package:flutter/material.dart';
import 'package:flutter_application_1/chart/chart.dart';
import 'package:flutter_application_1/chart/confusion_matrix.dart';
import 'package:flutter_application_1/logic/binary.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // input data
    final x1 = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7];
    final x2 = [0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9];
    final yDesired = [1, 1, 1, 1, 0, 0, 0];
    double learningRate = 0.1;
    int maxIterations = 10;

    final binaryResult =
        testBinaryClassification(x1, x2, yDesired, maxIterations, learningRate);
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Binary Classification'),
              LineChartSample(
                eq: binaryResult['equation'].toString(),
                xValues: x1,
                yValues: x2,
              ),
              ConfusionMatrixUI(
                  confusionMatrix: binaryResult['confusionMatrix']),
              Text('SSE: ${binaryResult['sse']}'),
              Text('Equation: ${binaryResult['equation']}'),
              Text('Accuracy: ${binaryResult['accuracy']}'),
            ],
          ),
        ),
      ),
    );
  }
}
