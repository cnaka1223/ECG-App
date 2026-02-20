
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:ecg_app/ecg_graphs.dart';
import 'package:ecg_app/ecg_storage.dart';
import 'package:ecg_app/ecg_history.dart';

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



Future<void> store10Secs(BuildContext context) async{
  if (currPoint >= 3333){
    csvHelper.startNewFile();
    if (!await csvHelper.doesNameFileExist()){
      csvHelper.createNameFile();
    }
    
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





  


