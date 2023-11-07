import 'dart:math';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ether_ease/widgets/app_background.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({Key? key}) : super(key: key);

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  final _entriesCollection = FirebaseFirestore.instance.collection('entries');
  final Map<String, int> emotionCounts = {
    'feliz': 0,
    'emocionado': 0,
    'contento': 0,
    'neutro': 0,
    'reflexivo': 0,
    'triste': 0,
    'ansioso': 0,
    'estresado': 0,
    'frustrado': 0,
    'abrumado': 0,
    'enojado': 0,
  };

  final Map<String, int> countActivities = {
    'ejercicio': 0,
    'tarea': 0,
    'pasear': 0,
    'bailar': 0,
    'jugar': 0,
  };

  @override
  void initState() {
    super.initState();
    _fetchEmotionData();
  }

  _fetchEmotionData() async {
    final user = FirebaseAuth.instance.currentUser!;
    final snapshots =
        await _entriesCollection.where('user', isEqualTo: user.uid).get();

    for (var doc in snapshots.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final emotion = data['emotion'] as String?;
      final activity = data['activity'] as String?;

      if (emotion != null && emotionCounts.containsKey(emotion)) {
        emotionCounts[emotion] = emotionCounts[emotion]! + 1;
      }

      if (activity != null && countActivities.containsKey(activity)) {
        countActivities[activity] = countActivities[activity]! + 1;
      }
    }
    setState(() {});
  }

  List<Widget> _buildActivityBars(double maxBarWidth, int maxActivityCount) {
      final barColor = Colors.blue.shade400;
      return countActivities.entries.map((entry) {
      final activity = entry.key;
      final count = entry.value;
      final barWidth = (count / maxActivityCount) * maxBarWidth;

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 20,
              width: barWidth.isNaN
                  ? 0.0
                  : barWidth, 
              color: barColor,
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: Text(count.toString(),
                      style: const TextStyle(color: Colors.white)),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(activity.toUpperCase()),
          ],
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final maxBarWidth = screenWidth * 0.55;

    final maxEmotionCount = emotionCounts.values.reduce(max);
    final maxActivityCount = countActivities.values.reduce(max);

    return Scaffold(
      body: Stack(
        children: [
          const AppBackground(imagePath: 'assets/images/app_background.png'),
          Center(
            child: Card(
              color: Colors.green.shade900,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  margin: const EdgeInsets.all(10),
                  width: screenWidth * 0.92,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.green.shade50,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...emotionCounts.entries.map((entry) {
                          final emotion = entry.key;
                          final count = entry.value;
                          final barWidth =
                              (count / maxEmotionCount) * maxBarWidth;
                          return _buildBar(
                            color: Colors.green.shade400,
                            label: emotion.toUpperCase(),
                            barWidth: barWidth,
                            count: count,
                          );
                        }).toList(),
                        // Activity bars
                        ..._buildActivityBars(maxBarWidth, maxActivityCount),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBar(
      {required Color color,
      required String label,
      required double barWidth,
      required int count}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 20,
            width: barWidth.isNaN
                ? 0.0
                : barWidth, 
            color: color,
            child: Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 4.0),
                child: Text(count.toString(),
                    style: const TextStyle(color: Colors.white)),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(label),
        ],
      ),
    );
  }
}
