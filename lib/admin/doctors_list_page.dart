import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DoctorsListPage extends StatelessWidget {
  const DoctorsListPage({super.key});

  // 🗑️ Supprimer docteur
  Future<void> _deleteDoctor(BuildContext context, String docId) async {
    await FirebaseFirestore.instance.collection("users").doc(docId).delete();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Docteur supprimé avec succès")),
    );
  }

  // ✏️ Modifier docteur
  void _editDoctor(
    BuildContext context,
    String docId,
    String currentName,
    String currentSpeciality,
  ) {
    final nameController = TextEditingController(text: currentName);
    final specialityController =
        TextEditingController(text: currentSpeciality);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Modifier le docteur"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Nom"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: specialityController,
              decoration: const InputDecoration(labelText: "Spécialité"),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection("users")
                  .doc(docId)
                  .update({
                "name": nameController.text.trim(),
                "speciality": specialityController.text.trim(),
              });

              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Informations mises à jour")),
              );
            },
            child: const Text("Enregistrer"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Liste des docteurs"),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users")
            .where("role", isEqualTo: "doctor")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("Aucun docteur pour le moment."),
            );
          }

          final doctors = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: doctors.length,
            itemBuilder: (context, index) {
              final doc = doctors[index];
              final data = doc.data() as Map<String, dynamic>;

              final name = data["name"] ?? "Nom inconnu";
              final speciality = data["speciality"] ?? "Spécialité inconnue";

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                child: ListTile(
                  leading: const Icon(Icons.person, color: Colors.blue),
                  title: Text(name,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(speciality),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ✏️ Modifier
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.orange),
                        onPressed: () => _editDoctor(
                          context,
                          doc.id,
                          name,
                          speciality,
                        ),
                      ),

                      // 🗑️ Supprimer
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text("Confirmation"),
                              content: const Text(
                                  "Voulez-vous supprimer ce docteur ?"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text("Annuler"),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    _deleteDoctor(context, doc.id);
                                  },
                                  child: const Text("Supprimer"),
                                ),
                              ],
                            ),
                          );
                        },
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
