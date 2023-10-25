import 'package:ether_ease/functions/util.dart';
import 'package:ether_ease/widgets/app_background.dart';
import 'package:ether_ease/widgets/mood_picker.dart';
import 'package:ether_ease/services/add_entries_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddEntry extends StatefulWidget {
  const AddEntry({super.key});

  @override
  State<StatefulWidget> createState() {
    return _AddEntryState();
  }
}

class _AddEntryState extends State<AddEntry> {
  final _form = GlobalKey<FormState>();
  final _addEntriesService = AddEntriesService();
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

  void _saveEntry() async {
    final isValid = _form.currentState!.validate();
    if (!isValid || _selectedDate == null) {
      return;
    }
    
    String docId = '${_addEntriesService.getCurrentUserId()}_${_selectedDate!.toUtc().toString().split(' ')[0]}';

    DocumentSnapshot snapshot = await _addEntriesService.entriesCollection.doc(docId).get();

    if (snapshot.exists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ya has agregado una entrada para este día.')),
      );
      return;
    } 

    _form.currentState!.save();
    try {
      await _addEntriesService.addEntry(
        best: _enteredBest,
        worst: _enteredWorst,
        additional: _enteredAdditional,
        emotion: _selectedEmotion!,
        date: _selectedDate!,
      );
      Navigator.of(context).pop();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ha ocurrido un error. Vuelve a intentarlo más tarde.')),
      );
    }
}


  @override
  Widget build(BuildContext context) {
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
