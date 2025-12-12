import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _prenomController = TextEditingController();
  final _nomController = TextEditingController();
  final _ageController = TextEditingController();
  final _telController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _loading = false;

  Future<void> registerUser() async {
    setState(() => _loading = true);

    try {
      // 1️⃣ Création compte Firebase
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      String uid = userCredential.user!.uid;

      // 2️⃣ Enregistrement Firestore
      await FirebaseFirestore.instance.collection("users").doc(uid).set({
        "email": _emailController.text.trim(),
        "role": "patient",
        "profile": {
          "prenom": _prenomController.text.trim(),
          "nom": _nomController.text.trim(),
          "age": int.tryParse(_ageController.text.trim()) ?? 0,
          "telephone": _telController.text.trim(),
        }
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Compte créé avec succès !")),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.message ?? "Erreur")));
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Créer un compte")),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            _field("Prénom", _prenomController),
            _field("Nom", _nomController),
            _field("Âge", _ageController, number: true),
            _field("Téléphone", _telController),
            _field("Email", _emailController),
            _field("Mot de passe", _passwordController, password: true),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: _loading ? null : registerUser,
              child: _loading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("S'inscrire"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController controller,
      {bool number = false, bool password = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextField(
        controller: controller,
        obscureText: password,
        keyboardType: number ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          labelText: label,
        ),
      ),
    );
  }
}
