import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddSuiviSantePage extends StatefulWidget {
  final String patientId;

  const AddSuiviSantePage({super.key, required this.patientId});

  @override
  State<AddSuiviSantePage> createState() => _AddSuiviSantePageState();
}

class _AddSuiviSantePageState extends State<AddSuiviSantePage> {
  final TextEditingController _controller = TextEditingController();
  bool isSaving = false;

  Future<void> saveSuivi() async {
    if (_controller.text.trim().isEmpty) return;

    setState(() => isSaving = true);

    await FirebaseFirestore.instance.collection("healthRecords").add({
      "patientId": widget.patientId,
      "text": _controller.text.trim(),
    });

    setState(() => isSaving = false);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ajouter un Suivi Santé"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),

        // 🔥 Récupération du patient
        child: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection("users")
              .doc(widget.patientId)
              .get(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.data!.exists) {
              return const Center(child: Text("Patient introuvable"));
            }

            final patient = snapshot.data!.data() as Map<String, dynamic>;
            final profile = patient["profile"] ?? {};
            final prenom = profile["prenom"] ?? "";
            final nom = profile["nom"] ?? "";

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ✅ Nom + Prénom au lieu de l'ID
                Text(
                  "Patient : $prenom $nom",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                TextField(
                  controller: _controller,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: "Écrire le suivi médical...",
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isSaving ? null : saveSuivi,
                    child: isSaving
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Enregistrer"),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
