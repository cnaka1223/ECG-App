import 'package:csv/csv.dart';
import 'package:flutter/services.dart' show rootBundle;

Future<List<double>> readLead1CSV() async {
  final contents = await rootBundle.loadString('./assets/100.csv');

  final csvToList = const CsvToListConverter().convert(contents);
  List<double> lead1 = [];

  for (int i = 1; i < 10000; i++) {
    lead1.add(csvToList[i][0].toDouble());
  }

  return lead1;
}

Future<List<double>> readLead2CSV() async {
  final contents = await rootBundle.loadString('./assets/100.csv');

  final csvToList = const CsvToListConverter().convert(contents);
  List<double> lead2 = [];

  for (int i = 1; i < 10000; i++) {
    lead2.add(csvToList[i][1].toDouble());
  }

  return lead2;
}


