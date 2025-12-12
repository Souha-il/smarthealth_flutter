// lib/doctor/patients_list_page.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PatientsListPage extends StatelessWidget {
  final bool isForSuivi;
  final bool isForDossier;

  const PatientsListPage({
    super.key,
    this.isForSuivi = false,
    this.isForDossier = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Liste des patients"),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("appointments")
            .where("status", isEqualTo: "accepted") // 🔥 seulement acceptés
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final patients = snapshot.data!.docs;

          if (patients.isEmpty) {
            return const Center(
              child: Text("Aucun patient pour le moment."),
            );
          }

          return ListView.builder(
            itemCount: patients.length,
            itemBuilder: (context, index) {
              final p = patients[index];

              return Card(
                margin: const EdgeInsets.all(12),
                child: ListTile(
                  title: Text("Patient : ${p["patientName"]}"),
                  subtitle: Text("RDV accepté"),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () {
                    final patientId = p["patientId"];

                    // Navigation selon type
                    if (isForSuivi) {
                      Navigator.pushNamed(
                        context,
                        "/add_suivi",
                        arguments: patientId,
                      );
                    } else if (isForDossier) {
                      Navigator.pushNamed(
                        context,
                        "/update_folder",
                        arguments: patientId,
                      );
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
