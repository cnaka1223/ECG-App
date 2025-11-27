import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:ecg_app/ecg_data.dart';

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
              SizedBox(height: 200, child: ECGGraph1(),),
              SizedBox(height: 10),
              const Text(
              "Lead 2",
              style: TextStyle(fontSize: 24)),
            SizedBox(height: 200, child: ECGGraph2(),),
            SizedBox(height: 20),
            const Text(
              "Stats: ",
              style: TextStyle(fontSize: 24)),
              const Text(
              "Average Heart Rate: --",
              style: TextStyle(fontSize: 18)),
              const Text(
              "Resting Heart Rate: --",
              style: TextStyle(fontSize: 18)),
              const Text(
              "Max Heart Rate: --",
              style: TextStyle(fontSize: 18)),
              const Text(
              "Min Heart Rate: --",
              style: TextStyle(fontSize: 18))
            
            ]))
      );
  }
}

class ECGGraph1 extends StatefulWidget{
  const ECGGraph1({super.key});

  @override
  GraphState1 createState() => GraphState1();
}

class GraphState1 extends State<ECGGraph1>{

  List<double> lead1Points = [];
  List<FlSpot> points = [];

  double x = 0;
  int y = 0;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    lead1Points = await readLead1CSV();
    Timer.periodic(const Duration(milliseconds: 3), (timer){
      setState((){
        if (y == 10000){
          y = 0;
        }
        
        points.add(FlSpot(x, lead1Points[y]));
            
        if (points.length >= 1000){
          points.removeAt(0);
        }

        x++;
        y++;
      });
    });
  }

  @override
  Widget build(BuildContext context){
    if (points.isEmpty) {
      return const Center(child: Text('Loading ECG...'));
    }
    return LineChart(
      LineChartData(
        minX: x-1000,
        maxX: x,
        minY: -1,
        maxY: 1,
        lineBarsData: [LineChartBarData(spots: points,
          isCurved: true,
          color: Colors.red,
          barWidth: 2,
          )],
        titlesData: FlTitlesData(show: false),
      )
    );
  }
}

class ECGGraph2 extends StatefulWidget{
  const ECGGraph2({super.key});

  @override
  GraphState2 createState() => GraphState2();
}

class GraphState2 extends State<ECGGraph2>{

  List<double> lead2Points = [];
  List<FlSpot> points = [];

  double x = 0;
  int y = 0;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    lead2Points = await readLead2CSV();
    Timer.periodic(const Duration(milliseconds: 3), (timer){
      setState((){
        if (y == 10000){
          y = 0;
        }
        
        points.add(FlSpot(x, lead2Points[y]));
            
        if (points.length == 1000){
          points.removeAt(0);
        }

        x++;
        y++;
      });
    });
  }

  @override
  Widget build(BuildContext context){
    if (points.isEmpty) {
      return const Center(child: Text('Loading ECG...'));
    }
    return LineChart(
      LineChartData(
        minX: x-1000,
        maxX: x,
        minY: -1,
        maxY: 1,
        lineBarsData: [LineChartBarData(spots: points,
          isCurved: true,
          color: Colors.blue,
          barWidth: 2,
          )],
        titlesData: FlTitlesData(show: false),
      )
    );
  }
}

  


