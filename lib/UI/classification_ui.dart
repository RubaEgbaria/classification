import 'package:flutter/material.dart';
import 'package:flutter_application_1/UI/chart.dart';
import 'package:flutter_application_1/UI/confusion_matrix.dart';
import 'package:flutter_application_1/UI/mutli_equations_chart.dart';

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
    if (multiClassResult.isEmpty && binaryResult.isEmpty) {
      return const SizedBox.shrink();
    }
    return SingleChildScrollView(
      controller: ScrollController(),
      child: yDesired.toSet().length > 2
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  '- - One vs All - -',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                for (int i = 0; i < multiClassResult.length - 1; i++)
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          DataTable(
                            columns: const [
                              DataColumn(label: Text('Model')),
                              DataColumn(label: Text('Result')),
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
                  ),
                const Divider(),
                MutliEquationsChart(
                    equations: multiClassResult
                        .map((e) => e['equation'].toString())
                        .toList(),
                    xValues: x1,
                    yValues: x2,
                    yPred: multiClassResult[yDesired.toSet().length]['yPred']),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    DataTable(
                      columns: const [
                        DataColumn(label: Text('Model')),
                        DataColumn(label: Text('Result')),
                      ],
                      rows: [
                        DataRow(cells: [
                          const DataCell(Text('Equation')),
                          DataCell(Text(
                            '${multiClassResult[yDesired.toSet().length]['equation']}',
                            style: const TextStyle(fontSize: 10),
                          )),
                        ]),
                        DataRow(cells: [
                          const DataCell(Text('SSE')),
                          DataCell(Text(
                              '${multiClassResult[yDesired.toSet().length]['sse']}')),
                        ]),
                        DataRow(cells: [
                          const DataCell(Text('Accuracy')),
                          DataCell(Text(
                              '${multiClassResult[yDesired.toSet().length]['accuracy'].toStringAsFixed(2)}')),
                        ]),
                      ],
                    ),
                    ConfusionMatrixUI(
                        confusionMatrix:
                            multiClassResult[yDesired.toSet().length]
                                ['confusionMatrix']),
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
                  yDesired: yDesired,
                  classId: 0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    DataTable(
                      columns: const [
                        DataColumn(label: Text('Model')),
                        DataColumn(label: Text('Result')),
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
              ],
            ),
    );
  }
}
