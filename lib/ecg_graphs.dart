import 'package:fl_chart/fl_chart.dart';
import 'package:ecg_app/ecg_data.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:ecg_app/ecg_homepage.dart';

class ECGGraph1 extends StatefulWidget{
  final void Function(double avgHeartRate, double maxHeartRate, double minHeartRate)? statsUpdated;

  const ECGGraph1({super.key, this.statsUpdated});

  @override
  GraphState1 createState() => GraphState1();
}

class GraphState1 extends State<ECGGraph1>{

  List<FlSpot> points = [];

  double x = 0;
  int y = 0;
  double avg = 0;
  List<int> peakTimes = [];
  int total = 0;
  double max = 0;
  double min = 300;
  Timer? _timer;

  void calcAvg() {
    if (peakTimes.length < 2) return; 

    int total = 0;

    for (int i = 0; i < peakTimes.length - 1; i++) {
      total += peakTimes[i + 1] - peakTimes[i];
    }

    avg = total / (peakTimes.length - 1);
    avg = (avg * 3.33) / 1000;
    avg = 60 / avg;
    if (avg > max){
      max = avg;
    }
    if (avg < min){
      min = avg;
    }
    
    widget.statsUpdated?.call(avg, max, min);
    
}

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    
    lead1Global = await readLead1CSV();
    
    _timer = Timer.periodic(const Duration(milliseconds: 3), (timer){
      
      setState((){
        if (y == 10000){
          y = 0;
        }
        
        points.add(FlSpot(x, lead1Global[y]));
        currPoint = y;
        
        if ((y > 0 && y < lead1Global.length - 1) && (lead1Global[y] > 0.6 ) && (lead1Global[y] > lead1Global[y-1]) && (lead1Global[y] > lead1Global[y+1])){
          peakTimes.add(y);
          calcAvg();
          
        }
            
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
          barWidth: 1,
          )],
        titlesData: FlTitlesData(show: false),
      )
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    csvHelper.closeFile();
    super.dispose();
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
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    lead2Points = await readLead2CSV();
    _timer = Timer.periodic(const Duration(milliseconds: 3), (timer){
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
          barWidth: 1,
          )],
        titlesData: FlTitlesData(show: false),
      )
    );
  }
   @override
  void dispose() {
    _timer?.cancel();
    csvHelper.closeFile();
    super.dispose();
  }
}

class ECGGraph3 extends StatefulWidget{
  const ECGGraph3({super.key});

  @override
  GraphState3 createState() => GraphState3();
}

class GraphState3 extends State<ECGGraph3>{

  List<double> lead2Points = [];
  List<FlSpot> points = [];

  double x = 0;
  int y = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    lead2Points = await readLead2CSV();
    _timer = Timer.periodic(const Duration(milliseconds: 3), (timer){
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
          color: Colors.green,
          barWidth: 1,
          )],
        titlesData: FlTitlesData(show: false),
      )
    );
  }
   @override
  void dispose() {
    _timer?.cancel();
    csvHelper.closeFile();
    super.dispose();
  }
}