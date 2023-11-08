  
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

  // Contadores para las categorías de emociones
  Map<String, int> categoryCounts = {
    'positivo': 0,
    'neutro': 0,
    'negativo': 0,
  };

  // Mapeo de emociones a categorías
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

  @override
  void initState() {
    super.initState();
    _fetchEmotionData();
  }

  _fetchEmotionData() async {
    final user = FirebaseAuth.instance.currentUser!;
    final snapshots =
        await _entriesCollection.where('user', isEqualTo: user.uid).get();

    // Resetear los contadores
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

        // Determinar la categoría de la emoción y actualizar el contador
        final category = emotionToCategory[emotion];
        if (category != null) {
          categoryCounts[category] = (categoryCounts[category] ?? 0) + 1;
        }
      }
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final totalEmotions = emotionCounts.values.fold(0, (prev, count) => prev + count);
    final screenWidth = MediaQuery.of(context).size.width;
    final barMaxWidth = screenWidth * 0.75; // El ancho máximo para las barras
    final Color barColor = Colors.green.shade400; // Color definido para las barras
    Widget buildStatBar(String label, int count, Color color) {
      final barWidth = (count / totalEmotions) * barMaxWidth;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          children: [
            Text(label.toUpperCase()),
            const SizedBox(width: 10),
            Container(
              height: 20,
              width: barWidth.isNaN ? 0.0 : barWidth,
              color: color,
            ),
            const SizedBox(width: 10),
            Text('$count'),
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
     return Scaffold(
    appBar: AppBar(
      title: Text('Estadísticas de Ánimo'),
    ),
    body: SingleChildScrollView(
    child: Stack(
      children: [
        const AppBackground(imagePath: 'assets/images/app_background.png'),
        Padding( // Agregar padding para dar espacio al contenido
            padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Card(
                color: Colors.green.shade900,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    width: screenWidth * 0.92,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.green.shade50,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: emotionCounts.entries.map((entry) {
                        return buildStatBar(entry.key, entry.value, barColor);
                      }).toList(),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20), // Espacio entre las tarjetas
              Card(
                color: Colors.green.shade900,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    width: screenWidth * 0.92,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.blue.shade50,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: buildCategoryStats(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      )
     )
   );
  }
}
