import 'dart:io';
import 'package:path_provider/path_provider.dart';

class CSVHelper {
  File? _file;     
  IOSink? _sink;

  File? _nameFile;  
  IOSink? _nameSink;

  String? _currFilename;
  String? get currFilename => _currFilename;


  Future<void> startNewFile() async {
    final directory = await getExternalStorageDirectory();
    if (directory == null) throw Exception("Cannot access external storage");

    final now = DateTime.now();
    final filename =
        'ecg_'
        '${now.month.toString().padLeft(2, '0')}-'
        '${now.day.toString().padLeft(2, '0')}-'
        '${now.year}_'
        '${now.hour.toString().padLeft(2, '0')}-'
        '${now.minute.toString().padLeft(2, '0')}-'
        '${now.second.toString().padLeft(2, '0')}.csv';

    _currFilename = filename;

    _file = File('${directory.path}/$filename');
    _sink = _file!.openWrite(mode: FileMode.write);
    _sink!.writeln('lead1');


  }
  
  Future<void> createNameFile() async {
    final directory = await getExternalStorageDirectory();
    if (directory == null) throw Exception("Cannot access external storage");

    final filename = 'file_names.csv';
    _nameFile = File('${directory.path}/$filename');

   
    if (!await _nameFile!.exists()) {
      _nameSink = _nameFile!.openWrite(mode: FileMode.write);
      _nameSink!.writeln('Names:');
      await _nameSink!.flush();
      await _nameSink!.close();
      _nameSink = null;
    }
  }

  Future<bool> doesNameFileExist() async {
    final directory = await getExternalStorageDirectory();
    if (directory == null) return false;

    final file = File('${directory.path}/file_names.csv');
    return await file.exists();
  }

  
  Future<void> appendFilename(String? filename) async {
    final directory = await getExternalStorageDirectory();
    if (directory == null) throw Exception("Cannot access external storage");

    final fileNamesFile = File('${directory.path}/file_names.csv');

    final sink = fileNamesFile.openWrite(mode: FileMode.append);
    sink.writeln(filename);
    await sink.flush();
    await sink.close();
  }


  void appendRow(double lead1) {
    if (_sink == null) return;
    _sink!.writeln(lead1);
  }

  
  Future<void> closeFile() async {
    await _sink?.flush();
    await _sink?.close();
    _sink = null;
  }



Future<List<double>> readCSV(String filename) async {
  final directory = await getExternalStorageDirectory();
  if (directory == null) {
    throw Exception("Cannot access external storage");
  }

  final file = File('${directory.path}/$filename');

  if (!await file.exists()) {
    throw Exception("CSV file not found");
  }

  final lines = await file.readAsLines();

  List<double> voltages = [];

  for (int i = 1; i < lines.length; i++) {
    final line = lines[i].trim();
    if (line.isEmpty) continue;

    voltages.add(double.parse(line));
  }

  return voltages;
}

Future<List<String>> readFilenameCSV() async {
  final directory = await getExternalStorageDirectory();
  if (directory == null) {
    throw Exception("Cannot access external storage");
  }

  final file = File('${directory.path}/file_names.csv');

  if (!await file.exists()) {
    throw Exception("file_names.csv does not exist");
  }

  final contents = await file.readAsString();


  final lines = contents.split('\n');
  List<String> filenames = [];

  for (int i = 1; i < lines.length; i++) {
    final line = lines[i].trim();
    if (line.isNotEmpty) {
      filenames.add(line);
    }
  }

  return filenames;
}
}


