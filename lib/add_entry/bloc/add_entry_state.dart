import 'package:ether_ease/models/mood.dart';
import 'package:ether_ease/models/mood_activity.dart';
  
abstract class AddEntryState {}

class InitialState extends AddEntryState {}

class EntrySaveSuccessState extends AddEntryState {}

class EntrySaveErrorState extends AddEntryState {
  final String message;

  EntrySaveErrorState(this.message);
}

class EntryAlreadyExistsState extends AddEntryState {}

class EntryLoadSuccessState extends AddEntryState {
  final String best;
  final String worst;
  final String additional;
  final DateTime date;
  final Emotion emotion;
  final EmotionActivity emotionActivity;

  EntryLoadSuccessState({
    required this.best,
    required this.worst,
    required this.additional,
    required this.date,
    required this.emotion,
    required this.emotionActivity,
  });
}
