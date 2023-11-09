import 'package:ether_ease/models/mood.dart';
import 'package:ether_ease/models/mood_activity.dart';

abstract class AddEntryEvent {}

class SaveEntryEvent extends AddEntryEvent {
  final String best;
  final String worst;
  final String additional;
  final Emotion emotion;
  final DateTime date;
  final EmotionActivity emotionActivity;

  SaveEntryEvent(
    this.best,
    this.worst,
    this.additional,
    this.emotion,
    this.date,
    this.emotionActivity,
  );
}

class UpdateEntryEvent extends AddEntryEvent {
  final String userUid; 
  final String best;
  final String worst;
  final String additional;
  final Emotion emotion;
  final DateTime date;
  final EmotionActivity emotionActivity;

  UpdateEntryEvent({
    required this.userUid,
    required this.best,
    required this.worst,
    required this.additional,
    required this.emotion,
    required this.date,
    required this.emotionActivity,
  });
}
