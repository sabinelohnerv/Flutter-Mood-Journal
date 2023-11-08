import 'package:ether_ease/widgets/app_background.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _StatsScreenState();
  }
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

  Map<String, int> categoryCounts = {
    'positivo': 0,
    'neutro': 0,
    'negativo': 0,
  };

  Map<String, String> emotionToCategory = {
    'feliz': 'positivo',
    'emocionado': 'positivo',
    'contento': 'positivo',
    'neutro': 'neutro',
    'triste': 'negativo',
    'ansioso': 'negativo',
    'estresado': 'negativo',
    'frustrado': 'negativo',
    'abrumado': 'negativo',
    'enojado': 'negativo',
  };

  final Map<String, int> activityCounts = {
    "ejercicio": 0,
    "tarea": 0,
    "pasear": 0,
    "bailar": 0,
    "jugar": 0
  };

  @override
  void initState() {
    super.initState();
    _fetchEmotionData();
    _fetchActivityData();
  }

  _fetchEmotionData() async {
    final user = FirebaseAuth.instance.currentUser!;
    final snapshots =
        await _entriesCollection.where('user', isEqualTo: user.uid).get();

    emotionCounts.forEach((key, value) {
      emotionCounts[key] = 0;
    });
    categoryCounts.forEach((key, value) {
      categoryCounts[key] = 0;
    });

    for (var doc in snapshots.docs) {
      final data = doc.data();
      final emotion = data['emotion'] as String?;
      if (emotion != null) {
        emotionCounts[emotion] = (emotionCounts[emotion] ?? 0) + 1;

        final category = emotionToCategory[emotion];
        if (category != null) {
          categoryCounts[category] = (categoryCounts[category] ?? 0) + 1;
        }
      }
    }

    setState(() {});
  }

  _fetchActivityData() async {
    final user = FirebaseAuth.instance.currentUser!;
    final snapshots =
        await _entriesCollection.where('user', isEqualTo: user.uid).get();

    for (var doc in snapshots.docs) {
      final data = doc.data();
      final activity = data['activity'] as String?;

      if (activity != null && activityCounts.containsKey(activity)) {
        activityCounts[activity] = activityCounts[activity]! + 1;
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final totalEmotions =
        emotionCounts.values.fold(0, (prev, count) => prev + count);
    final screenWidth = MediaQuery.of(context).size.width;
    final barMaxWidth = screenWidth * 0.65;
    final Color barColor = Colors.green.shade400;
    final totalActivities = activityCounts.values.reduce((a, b) => a + b);
    Widget buildStatBar(String label, int count, Color color) {
      int maxTotal =
          totalEmotions > totalActivities ? totalEmotions : totalActivities;
      final barWidth = (count / maxTotal) * barMaxWidth;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            Container(
              height: 20,
              width: barWidth.isNaN ? 0.0 : barWidth,
              color: color,
            ),
            const SizedBox(width: 6),
            Text(label.toUpperCase()),
            const SizedBox(width: 6),
          ],
        ),
      );
    }

    List<Widget> buildCategoryStats() {
      List<Widget> stats = [];
      categoryCounts.forEach((category, count) {
        Color color;
        switch (category) {
          case 'positivo':
            color = Colors.blue;
            break;
          case 'neutro':
            color = Colors.amber;
            break;
          case 'negativo':
            color = Colors.red;
            break;
          default:
            color = Colors.grey;
        }
        stats.add(buildStatBar(category, count, color));
      });
      return stats;
    }

    return Stack(
      children: [
        const AppBackground(imagePath: 'assets/images/app_background.png'),
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  color: Colors.green.shade900,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      width: screenWidth * 0.92,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.green.shade50,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: emotionCounts.entries.map((entry) {
                            return buildStatBar(
                                entry.key, entry.value, barColor);
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Card(
                  color: Colors.green.shade900,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      width: screenWidth * 0.92,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.green.shade50,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: buildCategoryStats(),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Card(
                  color: Colors.green.shade900,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      width: screenWidth * 0.92,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.green.shade50,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: activityCounts.entries.map((entry) {
                            return buildStatBar(
                                entry.key, entry.value, barColor);
                          }).toList(),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
