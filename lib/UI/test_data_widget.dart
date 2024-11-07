import "package:flutter/material.dart";
import "package:flutter_application_1/logic/load_file.dart";
import "package:flutter_application_1/logic/one_vs_all.dart";

class TestDataWidget extends StatefulWidget {
  const TestDataWidget({super.key});

  @override
  State<TestDataWidget> createState() => _TestDataWidgetState();
}

class _TestDataWidgetState extends State<TestDataWidget> {
  List<double> x1 = [];
  List<double> x2 = [];
  late List<int> resultClass = List.filled(x1.length, 9);

  Future<void> loadData() async {
    final fields = await loadFile();
    if (fields == null) return;

    setState(() {
      x1 = fields.map((e) => double.parse(e[0].toString().trim())).toList();
      x2 = fields.map((e) => double.parse(e[1].toString().trim())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Upload test data file .csv"),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () async {
            await loadData();
          },
          child: const Text("Upload"),
        ),
        const SizedBox(height: 20),
        if (x1.isNotEmpty)
          DataTable(
            columns: const [
              DataColumn(label: Text("x1")),
              DataColumn(label: Text("x2")),
              DataColumn(label: Text("Predicted Class")),
            ],
            rows: List.generate(x1.length, (index) {
              return DataRow(cells: [
                DataCell(Text(x1[index].toString())),
                DataCell(Text(x2[index].toString())),
                DataCell(Text(!resultClass.contains(9)
                    ? resultClass[index].toString()
                    : "Not classified")),
              ]);
            }),
          ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            setState(() {
              resultClass = predictMultiClassData(x1, x2);
            });
          },
          child: const Text("Test Classification"),
        ),
      ],
    );
  }
}
