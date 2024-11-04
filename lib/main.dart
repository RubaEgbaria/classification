import 'package:flutter/material.dart';
import 'package:flutter_application_1/chart/chart.dart';
// import 'package:flutter_application_1/chart/confusion_matrix.dart';
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
    double learningRate = 0.2;
    int maxIterations = 1000;

    // final binaryResult =
    //     testBinaryClassification(x1, x2, yDesired, maxIterations, learningRate);
    final multiClassResult =
        testMultiClassification(x1, x2, yDesired, maxIterations, learningRate);
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            // children: [
            //   const Text('Binary Classification'),
            //   LineChartSample(
            //     eq: binaryResult['equation'].toString(),
            //     xValues: x1,
            //     yValues: x2,
            //   ),
            //   ConfusionMatrixUI(
            //       confusionMatrix: binaryResult['confusionMatrix']),
            //   Text('SSE: ${binaryResult['sse']}'),
            //   Text('Equation: ${binaryResult['equation']}'),
            //   Text('Accuracy: ${binaryResult['accuracy']}'),
            // ],
            children: [
              const Text('Multi Classification'),
              for (int i = 0; i < multiClassResult.length; i++)
                Column(
                  children: [
                    LineChartSample(
                        eq: multiClassResult[i]['equation'].toString(),
                        xValues: x1,
                        yValues: x2,
                        yDesired: yDesired,
                        classId: i),
                    // ConfusionMatrixUI(
                    //     confusionMatrix: multiClassResult[i]
                    //         ['confusionMatrix']),
                    // Text('SSE: ${multiClassResult[i]['sse']}'),
                    Text("Class $i"),
                    Text('Equation: ${multiClassResult[i]['equation']}'),
                    // Text('Accuracy: ${multiClassResult[i]['accuracy']}'),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
