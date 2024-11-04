import 'package:flutter/material.dart';

class ConfusionMatrixUI extends StatelessWidget {
  final Map<String, int> confusionMatrix;

  const ConfusionMatrixUI({super.key, required this.confusionMatrix});

  @override
  Widget build(BuildContext context) {
    List<List<int>> matrix = [
      [
        confusionMatrix['True Positive'] ?? 0,
        confusionMatrix['False Positive'] ?? 0
      ],
      [
        confusionMatrix['False Negative'] ?? 0,
        confusionMatrix['True Negative'] ?? 0
      ],
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Confusion Matrix',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        DataTable(
          columns: const [
            DataColumn(label: Text('')),
            DataColumn(label: Text('PP')),
            DataColumn(label: Text('PN')),
          ],
          rows: [
            DataRow(cells: [
              const DataCell(Text('AP')),
              DataCell(Text('${matrix[0][0]}')),
              DataCell(Text('${matrix[0][1]}')),
            ]),
            DataRow(cells: [
              const DataCell(Text('AN')),
              DataCell(Text('${matrix[1][0]}')),
              DataCell(Text('${matrix[1][1]}')),
            ]),
          ],
        ),
      ],
    );
  }
}
