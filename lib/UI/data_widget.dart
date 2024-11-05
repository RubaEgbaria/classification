import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/UI/classification_ui.dart';
import 'package:flutter_application_1/logic/load_file.dart';
import 'package:flutter_application_1/logic/one_vs_all.dart';

class DataWidget extends StatefulWidget {
  const DataWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DataWidgetState createState() => _DataWidgetState();
}

class _DataWidgetState extends State<DataWidget> {
  List<double> x1 = [];
  List<double> x2 = [];
  List<int> yDesired = [];
  double? learningRate;
  int? maxIterations;

  List<Map<String, dynamic>> multiClassResult = [];
  Map<String, dynamic> binaryClassResult = {};

  void loadData() async {
    final fields = await loadFile();
    if (fields == null) return;

    setState(() {
      x1 = fields.map((e) => double.parse(e[0].toString().trim())).toList();
      x2 = fields.map((e) => double.parse(e[1].toString().trim())).toList();
      yDesired = fields.map((e) => int.parse(e[2].toString().trim())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      dragStartBehavior: DragStartBehavior.down,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // title
            const Text(
              "Binary/Multi-Class Classification",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            // intro
            const Text(
              "Hello, this program will classify data using one vs all method\n"
              "The data must be in .csv format with 3 columns: x1, x2, yDesired",
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            const Text("Import data .csv file"),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: loadData,
              child: const Text("Load data .csv"),
            ),
            const SizedBox(height: 20),
            if (x1.isNotEmpty && x2.isNotEmpty && yDesired.isNotEmpty)
              DataTable(
                dataRowColor: WidgetStateProperty.resolveWith<Color>(
                    (Set<WidgetState> states) {
                  if (states.contains(WidgetState.selected)) {
                    return Theme.of(context)
                        .colorScheme
                        .primary
                        .withOpacity(0.03);
                  }
                  return Theme.of(context)
                      .colorScheme
                      .primary
                      .withOpacity(0.07);
                }),
                headingRowColor: WidgetStateProperty.resolveWith<Color>(
                    (Set<WidgetState> states) {
                  if (states.contains(WidgetState.selected)) {
                    return Theme.of(context)
                        .colorScheme
                        .primary
                        .withOpacity(0.08);
                  }
                  return Theme.of(context)
                      .colorScheme
                      .primary
                      .withOpacity(0.15);
                }),
                columns: const [
                  DataColumn(label: Text('x1')),
                  DataColumn(label: Text('x2')),
                  DataColumn(label: Text('yDesired')),
                ],
                rows: List.generate(x1.length, (index) {
                  return DataRow(cells: [
                    DataCell(Text(x1[index].toString())),
                    DataCell(Text(x2[index].toString())),
                    DataCell(Text(yDesired[index].toString())),
                  ]);
                }),
              ),
            const SizedBox(height: 20),
            SizedBox(
              width: 250,
              child: TextField(
                decoration: const InputDecoration(labelText: "Learning Rate"),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    learningRate = double.tryParse(value) ?? learningRate;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 250,
              child: TextField(
                decoration: const InputDecoration(labelText: "Max Iterations"),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  setState(() {
                    maxIterations = int.tryParse(value);
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  multiClassResult = testMultiClassification(
                      x1, x2, yDesired, maxIterations!, learningRate!);

                  binaryClassResult = testBinaryClassification(
                      x1, x2, yDesired, maxIterations!, learningRate!);
                });
              },
              child: const Text("Start Classification"),
            ),
            const SizedBox(height: 20),

            const Divider(),
            const SizedBox(height: 20),
            ClassificationUi(
                multiClassResult: multiClassResult,
                binaryResult: binaryClassResult,
                x1: x1,
                x2: x2,
                yDesired: yDesired),
          ],
        ),
      ),
    );
  }
}
