import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emedic/models/medical_history.dart';

class MedicalProvider {
  final _collectionName = "prescription";
  Firestore _firestore = Firestore.instance;

  Future<void> setMedicalData(MedicalHistory medicalHistory) async {
    return await _firestore
        .collection(_collectionName)
        .document()
        .setData(medicalHistory.toMap());
  }

  Stream<QuerySnapshot> getMedicalData(String uid) {
    final data=  _firestore
        .collection(_collectionName)
    .where("patientId",isEqualTo: uid)
        .orderBy("createdAt", descending: true)
        .snapshots();
    return data;
  }
  Future<MedicalHistory> getMedicalHistoryByID(String id, String uid) async {
    DocumentSnapshot snapshot = await Firestore.instance
        .collection(_collectionName)
        .document(id)
        .get();
    MedicalHistory medicalHistory = MedicalHistory.fromMap(snapshot.data);
    return medicalHistory;
  }
}
