import 'package:ecg_app/ecg_homepage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const ECGApp());
}

class ECGApp extends StatelessWidget{
  const ECGApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: ECGHomepage(),
    );
  }
}