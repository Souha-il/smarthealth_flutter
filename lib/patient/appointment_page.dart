import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AppointmentPage extends StatefulWidget {
  final bool showOnlyUserAppointments;

  const AppointmentPage({super.key, this.showOnlyUserAppointments = false});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  String? doctorId;
  String? doctorName;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  Future<void> sendRequest() async {
    if (doctorId == null || selectedDate == null || selectedTime == null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Champs manquants.")));
      return;
    }

    final user = FirebaseAuth.instance.currentUser!;
    final patientDoc =
        await FirebaseFirestore.instance.collection("users").doc(user.uid).get();

    await FirebaseFirestore.instance.collection("appointments").add({
      "doctorId": doctorId,
      "doctorName": doctorName,
      "patientId": user.uid,
      "patientName": patientDoc["profile"]["prenom"],
      "date": "${selectedDate!.year}-${selectedDate!.month}-${selectedDate!.day}",
      "time": "${selectedTime!.hour}:${selectedTime!.minute}",
      "status": "pending",
      "createdAt": Timestamp.now(),
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Demande envoyée.")));
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.showOnlyUserAppointments
            ? "Mes rendez-vous"
            : "Prendre un RDV"),
      ),

      body: widget.showOnlyUserAppointments
          ? _buildMyAppointments(uid)
          : _buildTakeAppointment(),
    );
  }

  // 🔹 Afficher mes rdv
  Widget _buildMyAppointments(String uid) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("appointments")
          .where("patientId", isEqualTo: uid)
          .snapshots(),
      builder: (_, snap) {
        if (!snap.hasData) return const Center(child: CircularProgressIndicator());
        final data = snap.data!.docs;

        return ListView.builder(
          itemCount: data.length,
          itemBuilder: (_, i) {
            final rdv = data[i].data() as Map<String, dynamic>;
            return Card(
              margin: const EdgeInsets.all(10),
              child: ListTile(
                title: Text("Docteur : ${rdv['doctorName']}"),
                subtitle: Text(
                    "${rdv['date']} à ${rdv['time']} • Statut : ${rdv['status']}"),
              ),
            );
          },
        );
      },
    );
  }

  // 🔹 Prendre RDV
  Widget _buildTakeAppointment() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text("Sélectionner un docteur"),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("users")
              .where("role", isEqualTo: "doctor")
              .snapshots(),
          builder: (_, snapshot) {
            if (!snapshot.hasData) return const CircularProgressIndicator();

            return DropdownButtonFormField(
              items: snapshot.data!.docs.map((doc) {
                final d = doc.data() as Map<String, dynamic>;
                return DropdownMenuItem(
                  value: doc.id,
                  child: Text(d["name"] ?? d["profile"]["nom"]),
                  onTap: () => doctorName = d["name"] ?? d["profile"]["nom"],
                );
              }).toList(),
              onChanged: (v) => doctorId = v,
              decoration: const InputDecoration(border: OutlineInputBorder()),
            );
          },
        ),

        const SizedBox(height: 20),

        ElevatedButton(
          child: const Text("Choisir une date"),
          onPressed: () async {
            selectedDate = await showDatePicker(
              context: context,
              firstDate: DateTime.now(),
              lastDate: DateTime(2030),
              initialDate: DateTime.now(),
            );
            setState(() {});
          },
        ),

        const SizedBox(height: 20),

        ElevatedButton(
          child: const Text("Choisir une heure"),
          onPressed: () async {
            selectedTime = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            setState(() {});
          },
        ),

        const SizedBox(height: 20),

        ElevatedButton(
          onPressed: sendRequest,
          child: const Text("Envoyer la demande"),
        ),
      ],
    );
  }
}
