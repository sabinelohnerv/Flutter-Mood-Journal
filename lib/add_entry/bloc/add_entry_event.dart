import 'package:ether_ease/models/mood.dart';
import 'package:ether_ease/models/mood_activity.dart';

abstract class AddEntryEvent {}

class SaveEntryEvent extends AddEntryEvent {
  final String best;
  final String worst;
  final String additional;
  final Emotion emotion;
  final DateTime date;
  final EmotionActivity emotionactivity;

  SaveEntryEvent(this.best, this.worst, this.additional, this.emotion,
      this.date, this.emotionactivity);
}