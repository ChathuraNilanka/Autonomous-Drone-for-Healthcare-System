import 'package:flutter/foundation.dart';

class MedicalHistory{
  dynamic amount;
  String id;
  DateTime createdAt;
  String description;
  String docId;
  String docName;
  DateTime expDate;
  String patientId;
  String patientName;
  String prescription;
  bool repeat;
  String status;

  MedicalHistory({
    @required this.amount,
    @required this.createdAt,
    @required this.description,
    @required this.docId,
    @required this.docName,
    @required this.expDate,
    @required this.patientId,
    @required this.patientName,
    @required this.prescription,
    @required this.repeat,
    @required this.status,
  });

  factory MedicalHistory.fromMap(Map<String, dynamic> map) {
    return new MedicalHistory(
      amount: map['amount']??"1000.00",
      createdAt: map['createdAt'].toDate(),
      description: map['description'] as String,
      docId: map['docId'] as String,
      docName: map['docName'] as String,
      expDate: map['expDate'].toDate(),
      patientId: map['patientId'] as String,
      patientName: map['patientName'] as String,
      prescription: map['prescription'] as String,
      repeat: map['repeat'] as bool,
      status: map['status'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    // ignore: unnecessary_cast
    return {
      'amount': this.amount,
      'createdAt': this.createdAt,
      'description': this.description,
      'docId': this.docId,
      'docName': this.docName,
      'expDate': this.expDate,
      'patientId': this.patientId,
      'patientName': this.patientName,
      'prescription': this.prescription,
      'repeat': this.repeat,
      'status': this.status,
    } as Map<String, dynamic>;
  }
}