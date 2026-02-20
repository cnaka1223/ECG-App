import 'package:flutter/material.dart';
import 'package:ecg_app/ecg_homepage.dart';

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
            onTap: () async {
              Navigator.pop(context); 

              final data = await openRecording(name);

              List<int> historyPeakTime = [];

              for (int i = 1; i < data.length - 1; i++) {
                if (data[i] > 0.6 &&
                    data[i] > data[i - 1] &&
                    data[i] > data[i + 1]) {
                  historyPeakTime.add(i);
                }
              }

              if (historyPeakTime.length < 2) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Not enough peaks detected')),
                );
                return;
              }

              double historyAvg = 0;
              double historyMin = double.infinity;
              double historyMax = 0;

              for (int i = 0; i < historyPeakTime.length - 1; i++) {
                int diff = historyPeakTime[i + 1] - historyPeakTime[i];

                double rrSeconds = (diff * 3.33) / 1000;   
                double bpm = 60 / rrSeconds;

                historyAvg += bpm;

                if (bpm > historyMax) historyMax = bpm;
                if (bpm < historyMin) historyMin = bpm;
              }

              historyAvg = historyAvg / (historyPeakTime.length - 1);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => RecordingStatsPage(
                    filename: name,
                    avgHR: historyAvg,
                    maxHR: historyMax,
                    minHR: historyMin,
                  ),
                ),
              );
            },

          );
        },
      );
    },
  );
}

Future<List<double>> openRecording(String filename) async {
  Future<List<double>> currFile = csvHelper.readCSV(filename);

  return currFile;
}

class RecordingStatsPage extends StatelessWidget {
  final String filename;
  final double avgHR;
  final double maxHR;
  final double minHR;

  const RecordingStatsPage({
    super.key,
    required this.filename,
    required this.avgHR,
    required this.maxHR,
    required this.minHR,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(filename),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Heart Rate Statistics",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 30),

            Text(
              "Average HR: ${avgHR.toStringAsFixed(1)} BPM",
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),

            Text(
              "Maximum HR: ${maxHR.toStringAsFixed(1)} BPM",
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 10),

            Text(
              "Minimum HR: ${minHR.toStringAsFixed(1)} BPM",
              style: const TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}