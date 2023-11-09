import 'package:ether_ease/widgets/app_background.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmotionByTypeStatsScreen extends StatefulWidget {
  const EmotionByTypeStatsScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _EmotionByTypeStatsScreenState();
  }
}

class _EmotionByTypeStatsScreenState extends State<EmotionByTypeStatsScreen> {
  final _entriesCollection = FirebaseFirestore.instance.collection('entries');
  final Map<String, int> emotionCounts = {
    'positivas': 0,
    'neutras': 0,
    'negativas': 0,
  };

  final List<String> positiveEmotions = ['feliz', 'emocionado', 'contento'];
  final List<String> neutralEmotions = ['reflexivo', 'neutro'];
  final List<String> negativeEmotions = [
    'triste',
    'ansioso',
    'estresado',
    'frustrado',
    'abrumado',
    'enojado'
  ];

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
      final data = doc.data();
      final emotion = data['emotion'] as String?;

      if (emotion != null) {
        if (positiveEmotions.contains(emotion)) {
          emotionCounts['positivas'] = emotionCounts['positivas']! + 1;
        } else if (neutralEmotions.contains(emotion)) {
          emotionCounts['neutras'] = emotionCounts['neutras']! + 1;
        } else if (negativeEmotions.contains(emotion)) {
          emotionCounts['negativas'] = emotionCounts['negativas']! + 1;
        }
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final totalEmotions = emotionCounts.values.reduce((a, b) => a + b);
    final barColor = Colors.green.shade400;
    double screenWidth = MediaQuery.of(context).size.width;
    double maxBarWidth = screenWidth * 0.55;
    int maxCount = emotionCounts.values.reduce((a, b) => a > b ? a : b);

    return Stack(
      children: [
        const AppBackground(imagePath: 'assets/images/app_background.png'),
        Center(
          child: Card(
            color: Colors.green.shade900,
            child: Padding(
              padding: const EdgeInsets.all(6.0),
              child: Container(
                margin: const EdgeInsets.all(10),
                width: screenWidth * 0.92,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.green.shade50,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: emotionCounts.entries.map((entry) {
                      final emotionCategory = entry.key;
                      final count = entry.value;

                      final barWidth = totalEmotions == 0
                          ? 0
                          : (count / maxCount) * maxBarWidth;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              height: 20,
                              width: barWidth.toDouble(),
                              color: barColor,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 4.0),
                                  child: Text(
                                    entry.value.toString(),
                                    style:
                                        TextStyle(color: Colors.grey.shade700),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(emotionCategory.toUpperCase()),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
