import 'package:ether_ease/add_entry/bloc/add_entry_bloc.dart';
import 'package:ether_ease/add_entry/bloc/add_entry_event.dart';
import 'package:ether_ease/add_entry/bloc/add_entry_state.dart';
import 'package:ether_ease/functions/util.dart';
import 'package:ether_ease/widgets/app_background.dart';
import 'package:ether_ease/add_entry/widgets/mood_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddEntry extends StatefulWidget {
  const AddEntry({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AddEntryState();
  }
}

class _AddEntryState extends State<AddEntry> {
  final _form = GlobalKey<FormState>();
  String _enteredBest = "";
  String _enteredWorst = "";
  String _enteredAdditional = "";
  DateTime? _selectedDate;
  var _selectedEmotion;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final threeDaysAgo = now.subtract(const Duration(days: 3));
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: threeDaysAgo,
      lastDate: now,
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  void _saveEntry() {
    final isValid = _form.currentState!.validate();
    if (!isValid || _selectedDate == null || _selectedEmotion == null) {
      return;
    }

    _form.currentState!.save();
    context.read<AddEntryBloc>().add(
          SaveEntryEvent(
            _enteredBest,
            _enteredWorst,
            _enteredAdditional,
            _selectedEmotion!,
            _selectedDate!,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddEntryBloc, AddEntryState>(
      listener: (context, state) {
        if (state is EntrySaveSuccessState) {
          Navigator.of(context).pop();
        } else if (state is EntryAlreadyExistsState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Ya has agregado una entrada para este día.')),
          );
        } else if (state is EntrySaveErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: addEntryForm(context),
    );
  }

  Scaffold addEntryForm(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Row(
          children: [
            SizedBox(
              width: 26,
            ),
            Image(
              image: AssetImage('assets/images/logo-2.png'),
              height: 55,
              width: 55,
              color: Colors.white,
            ),
            SizedBox(
              width: 2,
            ),
            Text(
              'Ether Ease',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        children: [
          const AppBackground(imagePath: 'assets/images/app_background.png'),
          Center(
            child: Container(
              padding: const EdgeInsets.all(8),
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color.fromARGB(255, 249, 246, 236),
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _form,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        const Text(
                          "¿Cómo estuvo tu día?",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Card(
                          color: Colors.green.shade50,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              children: [
                                Text(
                                  "¿Qué fue lo mejor de tu día?",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade800),
                                ),
                                TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return '¡Debes ingresar algo!';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _enteredBest = value!;
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "¿Qué fue lo peor de tu día?",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade800),
                                ),
                                TextFormField(
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return '¡Debes ingresar algo!';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    _enteredWorst = value!;
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "Nota adicional:",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey.shade800),
                                ),
                                const SizedBox(
                                  height: 2,
                                ),
                                TextFormField(
                                  validator: (value) {
                                    return null;
                                  },
                                  onSaved: (value) {
                                    if (value != null) {
                                      _enteredAdditional = value;
                                    } else {
                                      _enteredAdditional = "";
                                    }
                                  },
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "¿Qué emoción describe tu día mejor?",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey.shade800),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        MoodPicker(onSelectEmotion: (selectedEmotion) {
                          _selectedEmotion = selectedEmotion;
                        }),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              onPressed: _presentDatePicker,
                              icon: Icon(
                                Icons.calendar_month,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            Text(
                              _selectedDate == null
                                  ? 'Selecciona una fecha...'
                                  : formatDate(_selectedDate!),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        ElevatedButton(
                          onPressed: _saveEntry,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade50,
                            foregroundColor: Colors.green.shade900,
                          ),
                          child: const Text('Guardar'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
