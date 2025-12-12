import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Getter sécurisé de l’UID (évite les crash si null)
  String get uid => FirebaseAuth.instance.currentUser?.uid ?? "";

  // ─────────────────────────────────────────────
  //  🔵 1. Create user (utilisé pendant l'inscription)
  // ─────────────────────────────────────────────
  Future<void> createUser(String uid, String email) async {
    await _db.collection("users").doc(uid).set({
      "email": email,
      "createdAt": DateTime.now(),
    });
  }

  // ─────────────────────────────────────────────
  //  🔵 2. Save Profile
  // ─────────────────────────────────────────────
  Future<void> saveProfile(Map<String, dynamic> data) async {
    await _db.collection("users").doc(uid).set(
      {"profile": data},
      SetOptions(merge: true),
    );
  }

  Future<Map<String, dynamic>?> getProfile() async {
    final doc = await _db.collection("users").doc(uid).get();
    return doc.data()?["profile"];
  }

  // ─────────────────────────────────────────────
  //  🔵 3. Save Health
  // ─────────────────────────────────────────────
  Future<void> saveHealth(Map<String, dynamic> data) async {
    await _db.collection("users").doc(uid).set(
      {"health": data},
      SetOptions(merge: true),
    );
  }

  Future<Map<String, dynamic>?> getHealth() async {
    final doc = await _db.collection("users").doc(uid).get();
    return doc.data()?["health"];
  }

  // ─────────────────────────────────────────────
  //  🔵 4. Save Medical Folder
  // ─────────────────────────────────────────────
  Future<void> saveMedical(Map<String, dynamic> data) async {
    await _db.collection("users").doc(uid).set(
      {"medical": data},
      SetOptions(merge: true),
    );
  }

  Future<Map<String, dynamic>?> getMedical() async {
    final doc = await _db.collection("users").doc(uid).get();
    return doc.data()?["medical"];
  }
}
