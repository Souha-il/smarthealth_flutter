import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:smarthealth_app/doctor/doctor_rdv_page.dart';
import 'package:smarthealth_app/doctor/patients_list_page.dart';
import 'package:smarthealth_app/login_page.dart';

class DoctorHomePage extends StatelessWidget {
  const DoctorHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EEF8),

      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Text("Espace Docteur"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            },
          )
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            _menuCard(
              context,
              title: "Mes Rendez-vous",
              icon: Icons.calendar_month,
              page: const DoctorRDVPage(),
            ),

            _menuCard(
              context,
              title: "Dossiers Médicaux",
              icon: Icons.folder_copy,
              page: const PatientsListPage(isForDossier: true),
            ),

            _menuCard(
              context,
              title: "Ajouter un Suivi Santé",
              icon: Icons.monitor_heart,
              page: const PatientsListPage(isForSuivi: true),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Widget page,
  }) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(icon, size: 32, color: Colors.blue),
        title: Text(title, style: const TextStyle(fontSize: 18)),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => page),
          );
        },
      ),
    );
  }
}
