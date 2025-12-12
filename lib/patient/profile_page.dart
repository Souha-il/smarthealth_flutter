import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController lastnameCtrl = TextEditingController();
  final TextEditingController ageCtrl = TextEditingController();
  final TextEditingController phoneCtrl = TextEditingController();

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  /// 🔥 Charger le profil depuis Firestore
  Future<void> loadUserData() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get();

    if (!doc.exists) {
      setState(() => isLoading = false);
      return;
    }

    final data = doc.data() as Map<String, dynamic>;

    /// ⚠️ Le profil est dans un champ MAP => "profile"
    if (data.containsKey("profile")) {
      final profile = data["profile"] as Map<String, dynamic>;

      nameCtrl.text = profile["prenom"] ?? "";
      lastnameCtrl.text = profile["nom"] ?? "";
      phoneCtrl.text = profile["telephone"] ?? "";
      ageCtrl.text = profile["age"]?.toString() ?? "";
    }

    setState(() => isLoading = false);
  }

  /// 🔥 Sauvegarder les modifications
  Future<void> saveProfile() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance.collection("users").doc(uid).update({
      "profile": {
        "prenom": nameCtrl.text.trim(),
        "nom": lastnameCtrl.text.trim(),
        "telephone": phoneCtrl.text.trim(),
        "age": int.tryParse(ageCtrl.text) ?? 0,
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Profil mis à jour")),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mon Profil"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _field("Prénom", nameCtrl),
              _field("Nom", lastnameCtrl),
              _field("Téléphone", phoneCtrl),
              _field("Âge", ageCtrl, type: TextInputType.number),

              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: saveProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                ),
                child: const Text(
                  "Enregistrer",
                  style: TextStyle(fontSize: 18),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /// 🔧 Widget champ texte
  Widget _field(String label, TextEditingController controller,
      {TextInputType type = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        keyboardType: type,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
