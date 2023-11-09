import 'package:flutter/material.dart';
import 'statswidgets/activity_stats.dart';
import 'statswidgets/emotion_bytype_stats.dart';
import 'statswidgets/emotion_stats.dart';

class StatsScreen extends StatefulWidget {
  const StatsScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _StatsScreenState();
  }
}

class _StatsScreenState extends State<StatsScreen> {
  late Widget _currentStatsWidget;
  late String _appBarTitle;

  @override
  void initState() {
    super.initState();
    _currentStatsWidget = ActivityStatsScreen();
    _appBarTitle = 'Estadísticas por Actividades';
  }

  void updateAppBarTitle(String newTitle) {
    setState(() {
      _appBarTitle = newTitle;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_appBarTitle),
      ),
      body: Center(
        child: _currentStatsWidget, 
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              setState(() {
                _currentStatsWidget = ActivityStatsScreen();
                updateAppBarTitle('Estadísticas por Actvidades');
              });
            },
            child: Icon(Icons.sports),
            tooltip: 'Estadísticas de Actividad',
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                _currentStatsWidget = EmotionByTypeStatsScreen();
                updateAppBarTitle('Estadísticas por Tipos de Emociones');
              });
            },
            child: Icon(Icons.sentiment_satisfied),
            tooltip: 'Estadísticas por Tipos de Emociones',
          ),
          SizedBox(height: 16),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                _currentStatsWidget = EmotionStatsScreen();
                updateAppBarTitle('Estadísticas por Emociones');
              });
            },
            child: Icon(Icons.sentiment_very_satisfied),
            tooltip: 'Estadísticas de Emociones',
          ),
        ],
      ),
    );
  }
}
