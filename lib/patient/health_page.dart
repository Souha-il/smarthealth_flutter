import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HealthPage extends StatelessWidget {
  const HealthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String patientId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mon Suivi Santé"),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("healthRecords")
            .where("patientId", isEqualTo: patientId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final suivis = snapshot.data!.docs;

          if (suivis.isEmpty) {
            return const Center(child: Text("Aucun suivi pour le moment"));
          }

          return ListView.builder(
            itemCount: suivis.length,
            itemBuilder: (context, index) {
              final s = suivis[index];

              return Card(
                margin: const EdgeInsets.all(12),
                child: ListTile(
                  title: Text(s["text"]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
