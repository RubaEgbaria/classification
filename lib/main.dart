import 'package:flutter/material.dart';
import 'package:flutter_application_1/UI/classification_ui.dart';
import 'package:flutter_application_1/logic/one_vs_all.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // input data
    final x1 = [0.2, 0.14, 0.2, 0.12, 0.18, 0.5, 0.6, 0.56, 0.6];
    final x2 = [0.66, 0.7, 0.6, 0.2, 0.3, 0.23, 0.2, 0.9, 0.8];
    final yDesired = [0, 0, 0, 1, 1, 2, 2, 3, 3];
    double learningRate = 0.1;
    int maxIterations = 1000;

    final binaryResult =
        testBinaryClassification(x1, x2, yDesired, maxIterations, learningRate);
    final multiClassResult =
        testMultiClassification(x1, x2, yDesired, maxIterations, learningRate);
    return MaterialApp(
      home: Scaffold(
        body: Center(
          // enter the data .csv file (x1, x2, y)
          // enter learning rate
          // enter max iterations
          child: ClassificationUi(
            multiClassResult: multiClassResult,
            binaryResult: binaryResult,
            x1: x1,
            x2: x2,
            yDesired: yDesired,
          ),
        ),
      ),
    );
  }
}
