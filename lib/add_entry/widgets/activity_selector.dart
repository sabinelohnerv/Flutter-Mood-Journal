import 'package:flutter/material.dart';
import 'package:ether_ease/models/mood_activity.dart';

class MoodPickerActivity extends StatefulWidget {
  const MoodPickerActivity({super.key, required this.onSelectActivity, required selectedActivity});

  final Function(EmotionActivity?) onSelectActivity;

  @override
  State<StatefulWidget> createState() => _MoodPickerActivityState();
}

class _MoodPickerActivityState extends State<MoodPickerActivity> {
  EmotionActivity? _selectedActivity;

  final List<Mood> _moods =
      EmotionActivity.values.map((e) => Mood(name: e)).toList();

  @override
  void initState() {
    super.initState();
    _selectedActivity = _moods.first.name;
    widget.onSelectActivity(_selectedActivity);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 110,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _moods.length,
        itemBuilder: (context, index) {
          final mood = _moods[index];
          final isSelected = _selectedActivity == mood.name;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedActivity = isSelected ? null : mood.name;
                widget.onSelectActivity(_selectedActivity);
              });
            },
            child: Column(
              children: [
                Container(
                  width: 90,
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected
                          ? Colors.green.shade700
                          : Colors.transparent,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                 child: Flexible(
                    child: Image.asset(
                      emotionIconsActivity[mood.name]!,
                      fit: BoxFit.contain,
                      width: 60,
                      height: 60,
                    ),
                  ),
                ),
                Text(mood.name.toString().split('.').last.toUpperCase())
              ],
            ),
          );
        },
      ),
    );
  }
}
