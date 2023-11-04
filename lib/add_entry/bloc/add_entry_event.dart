import 'package:ether_ease/models/mood.dart';
abstract class AddEntryEvent {}

class SaveEntryEvent extends AddEntryEvent {
  final String best;
  final String worst;
  final String additional;
  final Emotion emotion;
  final DateTime date;

  SaveEntryEvent(this.best, this.worst, this.additional, this.emotion, this.date);
}