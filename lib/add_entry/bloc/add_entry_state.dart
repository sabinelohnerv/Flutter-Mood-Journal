abstract class AddEntryState {}

class InitialState extends AddEntryState {}

class EntrySaveSuccessState extends AddEntryState {}

class EntrySaveErrorState extends AddEntryState {
  final String message;

  EntrySaveErrorState(this.message);
}

class EntryAlreadyExistsState extends AddEntryState {}