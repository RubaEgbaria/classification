import 'package:flutter/material.dart';
import 'package:flutter_application_1/UI/chart.dart';
import 'package:flutter_application_1/UI/confusion_matrix.dart';

class ClassificationUi extends StatelessWidget {
  final List<Map<String, dynamic>> multiClassResult;
  final Map<String, dynamic> binaryResult;
  final List<double> x1;
  final List<double> x2;
  final List<int> yDesired;

  const ClassificationUi(
      {super.key,
      required this.multiClassResult,
      required this.binaryResult,
      required this.x1,
      required this.x2,
      required this.yDesired});

  @override
  Widget build(BuildContext context) {
    return Scrollable(
      axisDirection: AxisDirection.down,
      controller: ScrollController(),
      viewportBuilder: (context, offset) => SingleChildScrollView(
        controller: ScrollController(),
        child: multiClassResult.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Multi-Class Classification using One vs All',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  for (int i = 0; i < multiClassResult.length; i++)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 20),
                        Text(
                          'Class $i',
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        LineChartSample(
                            eq: multiClassResult[i]['equation'].toString(),
                            xValues: x1,
                            yValues: x2,
                            yDesired: yDesired,
                            classId: i),
                        DataTable(
                          columns: const [
                            DataColumn(label: Text('')),
                            DataColumn(label: Text('')),
                          ],
                          rows: [
                            DataRow(cells: [
                              const DataCell(Text('Equation')),
                              DataCell(
                                  Text('${multiClassResult[i]['equation']}')),
                            ]),
                            DataRow(cells: [
                              const DataCell(Text('SSE')),
                              DataCell(Text('${multiClassResult[i]['sse']}')),
                            ]),
                            DataRow(cells: [
                              const DataCell(Text('Accuracy')),
                              DataCell(Text(
                                  '${multiClassResult[i]['accuracy'].toStringAsFixed(2)}')),
                            ]),
                          ],
                        ),
                        ConfusionMatrixUI(
                            confusionMatrix: multiClassResult[i]
                                ['confusionMatrix']),
                        const Divider(thickness: 1, color: Colors.blueGrey),
                      ],
                    ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Binary Classification',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  LineChartSample(
                    eq: binaryResult['equation'].toString(),
                    xValues: x1,
                    yValues: x2,
                  ),
                  DataTable(
                    columns: const [
                      DataColumn(label: Text('')),
                      DataColumn(label: Text('')),
                    ],
                    rows: [
                      DataRow(cells: [
                        const DataCell(Text('Equation')),
                        DataCell(Text('${binaryResult['equation']}')),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text('SSE')),
                        DataCell(Text('${binaryResult['sse']}')),
                      ]),
                      DataRow(cells: [
                        const DataCell(Text('Accuracy')),
                        DataCell(Text(
                            '${binaryResult['accuracy'].toStringAsFixed(2)}')),
                      ]),
                    ],
                  ),
                  ConfusionMatrixUI(
                      confusionMatrix: binaryResult['confusionMatrix']),
                ],
              ),
      ),
    );
  }
}
