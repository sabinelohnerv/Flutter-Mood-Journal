import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ether_ease/models/mood.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddEntriesService {
  final CollectionReference entriesCollection =
      FirebaseFirestore.instance.collection('entries');

  String getCurrentUserId() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      throw Exception("Error al obtener un ID de usuario.");
    }
  }

  Future<void> addEntry({
    required String best,
    required String worst,
    String? additional,
    required Emotion emotion,
    required DateTime date,
  }) async {
    final userId = getCurrentUserId();
    // Incluye la hora, minutos, segundos y milisegundos en el docId para asegurarte de que sea único
    String docId = '${userId}_${date.toUtc().millisecondsSinceEpoch}';
    await entriesCollection.doc(docId).set(
      {
        'best': best,
        'worst': worst,
        'additional': additional,
        'emotion': emotion.toString().split('.').last,
        'date': date,
        'user': userId,
      },
    );
  }
}
