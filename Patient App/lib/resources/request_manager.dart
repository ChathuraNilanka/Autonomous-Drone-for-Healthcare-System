import 'package:cloud_firestore/cloud_firestore.dart';

class RequestManager{
  Firestore _firestore = Firestore.instance;
  Future<void> grantAccess(String doctorId,String documentId)async{
    _firestore.collection("doctor").document(doctorId).collection("patients").document(documentId)
        .updateData({
      "status":"accepted"
    });
  }
}