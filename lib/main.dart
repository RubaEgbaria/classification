import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/UI/data_widget.dart';
import 'package:flutter_application_1/UI/test_data_widget.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    // example of input data
    // final x1 = [0.2, 0.14, 0.2, 0.12, 0.18, 0.5, 0.6, 0.56, 0.6];
    // final x2 = [0.66, 0.7, 0.6, 0.2, 0.3, 0.23, 0.2, 0.9, 0.8];
    // final yDesired = [0, 0, 0, 1, 1, 2, 2, 3, 3];
    // final learningRate = 0.1;
    // final maxIterations = 1000;

    return MaterialApp(
      darkTheme: ThemeData.dark(useMaterial3: true),
      title: 'Classification App',
      home: const Scaffold(
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          dragStartBehavior: DragStartBehavior.down,
          child: Column(
            children: [
              DataWidget(),
              Divider(),
              TestDataWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
