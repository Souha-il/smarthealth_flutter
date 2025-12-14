import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DoctorRDVPage extends StatelessWidget {
  const DoctorRDVPage({super.key});

  @override
  Widget build(BuildContext context) {
    final String doctorId = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mes rendez-vous"),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("appointments")
            .where("doctorId", isEqualTo: doctorId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final rdvs = snapshot.data!.docs;

          if (rdvs.isEmpty) {
            return const Center(
              child: Text("Aucun rendez-vous pour le moment"),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: rdvs.length,
            itemBuilder: (context, index) {
              final rdv = rdvs[index];
              final status = rdv["status"];

              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Patient : ${rdv['patientName']}",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text("Date : ${rdv['date']} à ${rdv['time']}"),

                      const SizedBox(height: 8),

                      Text(
                        "Statut : $status",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: status == "pending"
                              ? Colors.orange
                              : status == "accepted"
                                  ? Colors.green
                                  : Colors.red,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // ✅ BOUTONS AVEC LARGEUR CONTRÔLÉE
                      if (status == "pending")
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                ),
                                onPressed: () {
                                  rdv.reference.update(
                                    {"status": "accepted"},
                                  );
                                },
                                child: const Text("Accepter"),
                              ),
                            ),

                            const SizedBox(width: 10),

                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                onPressed: () {
                                  rdv.reference.update(
                                    {"status": "rejected"},
                                  );
                                },
                                child: const Text("Rejeter"),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
