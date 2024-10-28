import 'package:flutter/material.dart';
import 'package:flutter_application_1/chart/draw_line.dart';
import 'package:flutter_application_1/logic/binary_classification.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            children: [
              const Text('Hello World!'),
              // LineChartSample6(
              //   equation1: testSampleData(),
              //   equation2: 'x^2',
              // ),
              LineChartSample(
                equation1: testSampleData(),
                // equation2: '0', // Another valid example
              ),
            ],
          ),
        ),
      ),
    );
  }
}
