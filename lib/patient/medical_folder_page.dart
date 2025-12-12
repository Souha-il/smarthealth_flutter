import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MedicalFolderPage extends StatelessWidget {
  const MedicalFolderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String patientId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mon dossier médical"),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("medicalFolders")
            .doc(patientId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.data!.exists) {
            return const Center(
              child: Text("Aucun dossier médical trouvé."),
            );
          }

          final data = snapshot.data!.data()!;

          return Padding(
            padding: const EdgeInsets.all(20),
            child: ListView(
              children: [
                infoCard("Antécédents", data["antecedents"]),
                infoCard("Allergies", data["allergies"]),
                infoCard("Maladies chroniques", data["maladiesChroniques"]),
                infoCard("Observations du docteur", data["observations"]),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget infoCard(String title, String text) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(text.isEmpty ? "Non renseigné" : text),
      ),
    );
  }
}
