import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:ecg_app/ecg_data.dart';
import 'package:ecg_app/ecg_storage.dart';

List<double> lead1Global = [];
int currPoint = 0;

CSVHelper csvHelper = CSVHelper();

class ECGHomepage extends StatefulWidget{
  const ECGHomepage({super.key});
  @override
  State<ECGHomepage> createState() => _ECGHomepageState();
}

class _ECGHomepageState extends State<ECGHomepage> {
  double avgHR = 0;
  double maxHR = 0;
  double minHR = 0;

  @override
    Widget build(BuildContext context) {
      return Scaffold(
          appBar: AppBar(title: const Text("ECG APP",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,),
            body: SingleChildScrollView(
          child: Padding(padding: const EdgeInsets.fromLTRB(40, 10, 40, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [const Text(
                "Lead 1",
                style: TextStyle(fontSize: 24)),
                SizedBox(height: 200, child: ECGGraph1(
                  statsUpdated: (avg, max, min){
                    setState(() {
                      avgHR = avg;
                      maxHR = max;
                      minHR = min;
                    });
                  }, 
                ),),
                SizedBox(height: 10),
                const Text(
                "Lead 2",
                style: TextStyle(fontSize: 24)),
              SizedBox(height: 200, child: ECGGraph2(),),
              SizedBox(height: 20),

              const Text(
                "Lead 3",
                style: TextStyle(fontSize: 24)),
              SizedBox(height: 200, child: ECGGraph3(),),
              SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: Builder(
                  builder: (context) {
                    return ElevatedButton(
                      onPressed: () {
                        store10Secs(context);
                      },
                      child: const Text(
                        'Store Last 10 Secs',
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 20),

                Text(
                "Stats: ",
                style: TextStyle(fontSize: 24)),
                Text(
                "Average Heart Rate: ${avgHR.toStringAsFixed(2)} BPM",
                style: TextStyle(fontSize: 18)),
                Text(
                "Resting Heart Rate: --",
                style: TextStyle(fontSize: 18)),
                Text(
                "Max Heart Rate: ${maxHR.toStringAsFixed(2)} BPM",
                style: TextStyle(fontSize: 18)),
                Text(
                "Min Heart Rate: ${minHR.toStringAsFixed(2)} BPM",
                style: TextStyle(fontSize: 18)),

                 SizedBox(height: 20),

                 Align(
                alignment: Alignment.center,
                child: Builder(
                  builder: (context) {
                    return ElevatedButton(
                      onPressed: () {
                        viewHistory(context);
                      },
                      child: const Text(
                        'History',
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 20)
              
              ]))
        ));
    }
}



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

void store10Secs(BuildContext context){
  if (currPoint >= 3333){
    csvHelper.startNewFile();
    csvHelper.createNameFile();
    csvHelper.appendFilename(csvHelper.currFilename);
    for (int i = 0; i < 3333; i++){
      csvHelper.appendRow(lead1Global[currPoint - 3333 + i]);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Data saved successfully'),
        duration: Duration(seconds: 1),
      ),
    );
  }
  else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Not enough data yet'),
        duration: Duration(seconds: 1),
      ),
    );
  }
}

Future<void> viewHistory(BuildContext context) async {
  final filenames = await csvHelper.readFilenameCSV();

  if (filenames.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No recordings found')),
    );
    return;
  }

  showModalBottomSheet(
    context: context,
    builder: (context) {
      return ListView.builder(
        itemCount: filenames.length,
        itemBuilder: (context, index) {
          final name = filenames[index];

          return ListTile(
            title: Text(name),
            onTap: () {
              Navigator.pop(context); 
              //openRecording(name);    // add reading function
            },
          );
        },
      );
    },
  );
}



  


