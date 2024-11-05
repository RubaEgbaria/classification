import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';

Future<List<List>?> loadFile() async {
  String filePath = '';

  final result = await FilePicker.platform.pickFiles(
      allowMultiple: false, type: FileType.custom, allowedExtensions: ['csv']);

  if (result == null) return null;

  filePath = result.files.first.path!;

  final input = File(filePath).openRead();
  final fields = await input
      .transform(utf8.decoder)
      .transform(const CsvToListConverter())
      .toList();

  return fields;
}
