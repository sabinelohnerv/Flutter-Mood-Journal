import 'package:ether_ease/add_entry/ui/add_entry.dart';

abstract class AddEntryState {}

class InitialState extends AddEntryState {}

class EntrySaveSuccessState extends AddEntryState {}

class EntrySaveErrorState extends AddEntryState {
  final String message;

  EntrySaveErrorState(this.message);
}

class EntryAlreadyExistsState extends AddEntryState {}

class EntryLoadSuccessState extends AddEntryState {
  final AddEntry entryData;

  EntryLoadSuccessState(this.entryData);
}
