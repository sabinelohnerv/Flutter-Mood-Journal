import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ether_ease/add_entry/bloc/add_entry_event.dart';
import 'package:ether_ease/add_entry/bloc/add_entry_state.dart';
import 'package:ether_ease/services/add_entries_service.dart';

class AddEntryBloc extends Bloc<AddEntryEvent, AddEntryState> {
  final AddEntriesService _addEntriesService;

  AddEntryBloc(this._addEntriesService) : super(InitialState()) {
    on<SaveEntryEvent>((event, emit) async {
      try {
        await _addEntriesService.addEntry(
          best: event.best,
          worst: event.worst,
          additional: event.additional,
          emotion: event.emotion,
          date: event.date,
        );
        emit(EntrySaveSuccessState());
      } catch (error) {
        emit(EntrySaveErrorState(
            'Ha ocurrido un error. Vuelve a intentarlo más tarde.'));
      }
    });
  }
}
