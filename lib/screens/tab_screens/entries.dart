import 'package:ether_ease/models/mood.dart';
import 'package:ether_ease/widgets/app_background.dart';
import 'package:ether_ease/widgets/entry_card.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EntriesScreen extends StatefulWidget {
  const EntriesScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _EntriesScreenState();
  }
}

class _EntriesScreenState extends State<EntriesScreen> {
  final CollectionReference _entriesCollection =
      FirebaseFirestore.instance.collection('entries');

  late final String? _userId;
  Emotion? _selectedEmotion;

  @override
  void initState() {
    super.initState();
    _userId = FirebaseAuth.instance.currentUser?.uid;
    if (_userId == null) {
      Navigator.pop(context);
    }
  }

  void _filterEntries(Emotion emotion) {
    setState(() {
      _selectedEmotion = emotion;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    Query query = _entriesCollection
        .where('user', isEqualTo: _userId)
        .orderBy('date', descending: true);

    if (_selectedEmotion != null) {
      query = query.where('emotion',
          isEqualTo: _selectedEmotion.toString().split('.').last);
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
        title: const Text('Tus Entradas de Diario'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: query.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Stack(children: [
              AppBackground(
                  imagePath: 'assets/images/app_background.png'),
              Center(
                child: Card(child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text("No hay ninguna entrada!"),
                )),
              ),
            ]);
          }

          var filteredEntries = snapshot.data!.docs.where((doc) {
            return _selectedEmotion == null ||
                doc['emotion'] == describeEnum(_selectedEmotion as Object);
          }).toList();

          return Stack(
            children: [
              const AppBackground(
                  imagePath: 'assets/images/app_background.png'),
              ListView.builder(
                itemCount: filteredEntries.length,
                itemBuilder: (context, index) {
                  return EntryCard(
                    entry: filteredEntries[index],
                  );
                },
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                child: ListView(
                  children: Emotion.values.map((emotion) {
                    return ElevatedButton(
                      onPressed: () => _filterEntries(emotion),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Image.asset(emotionIcons[emotion]!, width: 24),
                          const SizedBox(width: 8),
                          Text(describeEnum(emotion).toUpperCase()),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              );
            },
          );
        },
        tooltip: 'Filtrar por emoción',
        child: const Icon(Icons.filter_list),
      ),
    );
  }
}

String describeEnum(Object enumEntry) {
  final String description = enumEntry.toString();
  final int indexOfDot = description.indexOf('.');
  assert(indexOfDot != -1 && indexOfDot < description.length - 1);
  return description.substring(indexOfDot + 1);
}
