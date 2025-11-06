import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class ECGHomepage extends StatelessWidget{
  const ECGHomepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("ECG APP",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,),
        body: Padding(padding: const EdgeInsets.fromLTRB(40, 10, 40, 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [const Text(
              "Lead 1",
              style: TextStyle(fontSize: 24)),
              SizedBox(height: 200, child: ECGGraph(),),
              SizedBox(height: 10),
              const Text(
              "Lead 2",
              style: TextStyle(fontSize: 24)),
            SizedBox(height: 200, child: ECGGraph(),),
            SizedBox(height: 10),
            const Text(
              "Lead 3",
              style: TextStyle(fontSize: 24)),
            SizedBox(height: 200, child: ECGGraph(),)],)),
      );
  }
}

class ECGGraph extends StatefulWidget{
  const ECGGraph({super.key});

  @override
  GraphState createState() => GraphState();
}

class GraphState extends State<ECGGraph>{

  List<double> graphPoints = [];
  int x = -1;

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 1), (timer) {
      addPoint(Random().nextDouble() * 100);
    });
  }

  void addPoint(double newPoint){
    setState((){
      x++;
      graphPoints.add(newPoint);
    }
    
    );
  }

  @override
  Widget build(BuildContext context){
    return LineChart(
      LineChartData(
        minX: 0,
        maxX: 100,
        minY: 0,
        maxY: 100,
        lineBarsData: [LineChartBarData(spots: [FlSpot(0, 5), FlSpot(20, 5), FlSpot(50, graphPoints[x]), FlSpot(70, 5), FlSpot(90, 5)],
          isCurved: true,
          color: Colors.red,
          barWidth: 3,
          )],
        titlesData: FlTitlesData(show: false),
      )
    );
  }
}

  


