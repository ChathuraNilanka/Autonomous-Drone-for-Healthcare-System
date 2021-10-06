import 'package:cloud_firestore/cloud_firestore.dart';

class PrescriptionStorageProvider {
  final Firestore _firestore = Firestore.instance;
  final _collecion = "uploadPrescription";

  Future<void> updatePrescriptionCollection(
      DateTime now, String path, String uid) async {
    return await _firestore.collection(_collecion).document().setData(
        {"userID": uid, "path": path, "status": "Received", "createdAt": now});
  }
}
