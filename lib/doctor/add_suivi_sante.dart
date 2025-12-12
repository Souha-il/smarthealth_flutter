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
        child: Column(
          children: [
            Text("Patient: ${widget.patientId}"),
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
            ElevatedButton(
              onPressed: isSaving ? null : saveSuivi,
              child: isSaving
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Enregistrer"),
            ),
          ],
        ),
      ),
    );
  }
}
