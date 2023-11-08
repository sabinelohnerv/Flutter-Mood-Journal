import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ether_ease/functions/util.dart';

class EntryCard extends StatelessWidget {
  const EntryCard({super.key, required this.entry});

  final entry;

  @override
  Widget build(BuildContext context) {
    String best = entry['best'];
    String worst = entry['worst'];
    String? additional = entry['additional'];
    String emotion = entry['emotion'];
    DateTime date = (entry['date'] as Timestamp).toDate();
    String activity = entry['activity'].toString();
    activity = activity.substring(0, 1).toUpperCase() + activity.substring(1);

    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.green.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              SizedBox(
                width: 100,
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/$emotion.png',
                      width: 40,
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(emotion.toUpperCase()),
                  ],
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formatDate(date),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 2,
                    ),
                    Text(
                      'Mejor: $best',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                    Text(
                      'Peor: $worst',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                    Text(
                      'Adicional: $additional',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                    Text(
                      'Actividad: $activity',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
