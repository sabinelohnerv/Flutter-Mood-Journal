import 'package:flutter/material.dart';
import 'package:ether_ease/models/mood.dart';

class MoodPicker extends StatefulWidget {
  const MoodPicker({super.key, required this.onSelectEmotion, required selectedEmotion});

  final Function(Emotion?) onSelectEmotion;

  @override
  State<StatefulWidget> createState() {
    return _MoodPickerState();
  }
}

class _MoodPickerState extends State<MoodPicker> {
  Emotion? _selectedEmotion = Emotion.values.first;

  final List<Mood> _moods = Emotion.values.map((e) => Mood(name: e)).toList();

  @override
  void initState() {
    super.initState();
    widget.onSelectEmotion(_selectedEmotion);
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
          final isSelected = _selectedEmotion == mood.name;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedEmotion = isSelected ? null : mood.name;
                widget.onSelectEmotion(_selectedEmotion);
              });
            },
            child: Column(
              children: [
                Container(
                  width: 90,
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: isSelected ? Colors.green.shade700 : Colors.transparent,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Flexible(
                    child: Image.asset(
                      emotionIcons[mood.name]!,
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
