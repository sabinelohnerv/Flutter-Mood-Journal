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
          activity: event.emotionActivity,
        );
        emit(EntrySaveSuccessState());
      } catch (error) {
        emit(EntrySaveErrorState('Ha ocurrido un error al guardar la entrada. Vuelve a intentarlo más tarde.'));
      }
    });

    on<UpdateEntryEvent>((event, emit) async {
      try {
        await _addEntriesService.updateEntry(
          userUid: event.userUid, 
          best: event.best,
          worst: event.worst,
          additional: event.additional,
          emotion: event.emotion,
          date: event.date,
          activity: event.emotionActivity,
        );
        emit(EntrySaveSuccessState());
      } catch (error) {
        emit(EntrySaveErrorState('Ha ocurrido un error al actualizar la entrada. Vuelve a intentarlo más tarde.'));
      }
    });
  }
}
