import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';   // 🔥 important
import 'package:smarthealth_app/admin/add_doctor_page.dart';
import 'package:smarthealth_app/admin/doctors_list_page.dart';
import 'package:smarthealth_app/login_page.dart';    // 🔥 nécessaire pour retour login

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard Admin"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              // Déconnexion Firebase
              await FirebaseAuth.instance.signOut();

              // Redirection vers LoginPage
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            },
          )
        ],
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _adminButton(
            context,
            "Ajouter un docteur",
            const AddDoctorPage(),
          ),
          _adminButton(
            context,
            "Liste des docteurs",
            const DoctorsListPage(),
          ),
        ],
      ),
    );
  }

  Widget _adminButton(BuildContext ctx, String title, Widget page) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: ElevatedButton(
        onPressed: () => Navigator.push(
          ctx,
          MaterialPageRoute(builder: (_) => page),
        ),
        child: Text(title),
      ),
    );
  }
}
