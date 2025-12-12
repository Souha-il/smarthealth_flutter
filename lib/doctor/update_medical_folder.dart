import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UpdateMedicalFolderPage extends StatefulWidget {
  final String patientId;

  const UpdateMedicalFolderPage({super.key, required this.patientId});

  @override
  State<UpdateMedicalFolderPage> createState() => _UpdateMedicalFolderPageState();
}

class _UpdateMedicalFolderPageState extends State<UpdateMedicalFolderPage> {
  final _formKey = GlobalKey<FormState>();

  final antecedentsCtrl = TextEditingController();
  final allergiesCtrl = TextEditingController();
  final maladiesCtrl = TextEditingController();
  final observationsCtrl = TextEditingController();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadMedicalFolder();
  }

  Future<void> loadMedicalFolder() async {
    final doc = await FirebaseFirestore.instance
        .collection("medicalFolders")
        .doc(widget.patientId)
        .get();

    if (doc.exists) {
      antecedentsCtrl.text = doc["antecedents"] ?? "";
      allergiesCtrl.text = doc["allergies"] ?? "";
      maladiesCtrl.text = doc["maladiesChroniques"] ?? "";
      observationsCtrl.text = doc["observations"] ?? "";
    }

    setState(() => isLoading = false);
  }

  Future<void> saveData() async {
    await FirebaseFirestore.instance
        .collection("medicalFolders")
        .doc(widget.patientId)
        .set({
      "antecedents": antecedentsCtrl.text.trim(),
      "allergies": allergiesCtrl.text.trim(),
      "maladiesChroniques": maladiesCtrl.text.trim(),
      "observations": observationsCtrl.text.trim(),
      "updatedAt": FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Dossier médical mis à jour")));

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Modifier le dossier médical"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              buildField("Antécédents", antecedentsCtrl),
              buildField("Allergies", allergiesCtrl),
              buildField("Maladies chroniques", maladiesCtrl),
              buildField("Observations du docteur", observationsCtrl, maxLines: 4),

              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveData,
                child: const Text("Enregistrer"),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildField(String label, TextEditingController controller, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
