import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'appointment_page.dart';
import 'medical_folder_page.dart';
import 'health_page.dart';
import 'profile_page.dart';

import '../login_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5EEF8),

      appBar: AppBar(
        title: const Text("Espace Patient"),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
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
        child: ListView(
          children: [
            _menuCard(
              context,
              icon: Icons.calendar_month,
              title: "Prendre un rendez-vous",
              page: const AppointmentPage(),
            ),
            _menuCard(
              context,
              icon: Icons.event_available,
              title: "Mes rendez-vous",
              page: const AppointmentPage(showOnlyUserAppointments: true),
            ),
            _menuCard(
              context,
              icon: Icons.folder_copy,
              title: "Mon dossier médical",
              page: const MedicalFolderPage(),
            ),
            _menuCard(
              context,
              icon: Icons.monitor_heart,
              title: "Suivi santé",
              page: const HealthPage(),
            ),
            _menuCard(
              context,
              icon: Icons.person,
              title: "Mon profil",
              page: const ProfilePage(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _menuCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget page,
  }) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        leading: Icon(icon, size: 32, color: Colors.blue),
        title: Text(title, style: const TextStyle(fontSize: 18)),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        ),
      ),
    );
  }
}
