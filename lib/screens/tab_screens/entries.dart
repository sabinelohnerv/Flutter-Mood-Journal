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

  @override
  void initState() {
    super.initState();
    _userId = FirebaseAuth.instance.currentUser?.uid;
    if (_userId == null) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _entriesCollection
          .where('user', isEqualTo: _userId)
          .orderBy('date', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
              child: Text(
                  "No tienes entradas de diario todavía. \n¡Comienza hoy!"));
        }

        List<QueryDocumentSnapshot> entries = snapshot.data!.docs;

        return Stack(children: [
          const AppBackground(imagePath: 'assets/images/app_background.png'),
          ListView.builder(
            itemCount: entries.length,
            itemBuilder: (context, index) {
              return EntryCard(
                entry: entries[index],
              );
            },
          ),
        ]);
      },
    );
  }
}
