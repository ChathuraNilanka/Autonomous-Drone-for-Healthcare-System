import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class Order{
  String id;
  String referecnceId;
  dynamic amount;
  String userId;
  String orderStatus;
  String prescriptionType;
  LatLng liveTrack;
  LatLng location;
  DateTime createdAt;
  DateTime updatedAt;
  String patientName;
  String doctorName;
  String doctorId;
  String prescription;
  String contactNumber;

  Order({
    @required this.referecnceId,
    @required this.userId,
    @required this.orderStatus,
    @required this.prescriptionType,
    @required this.createdAt,
    @required this.updatedAt,
    this.location,
    @required this.doctorId,
    @required this.doctorName,
    @required this.patientName,
    @required this.prescription,
    @required this.contactNumber,
    this.liveTrack,
    this.amount
  });

  Map<String, dynamic> toMap() {
    return {
      'referecnceId': this.referecnceId,
      'prescription': this.prescription,
      'patientId': this.userId,
      'orderStatus': this.orderStatus,
      'prescriptionType': this.prescriptionType,
      'liveTrack': GeoPoint(0,0),
      'location': GeoPoint(location?.latitude??0,location?.longitude??0),
      'createdAt': this.createdAt,
      'updatedAt': this.updatedAt,
      'docName': this.doctorName,
      'docId': this.doctorId,
      'patientName': this.patientName,
      'contactNum': this.contactNumber,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    final livePoint = map['liveTrack'] as GeoPoint;
    final currentPoint = map['location'] as GeoPoint;

    return Order(
      referecnceId: map['referecnceId'] as String,
      userId: map['patientID'] as String,
      orderStatus: map['orderStatus'] as String,
      doctorName: map['docName'] as String,
      doctorId: map['docId'] as String,
      patientName: map['patientName'] as String,
      prescriptionType: map['prescriptionType'] as String,
      liveTrack: LatLng(livePoint.latitude,livePoint.longitude),
      location: LatLng(currentPoint.latitude,currentPoint.longitude),
      createdAt: map['createdAt'].toDate(),
      prescription: map['prescription'],
      updatedAt: map['updatedAt'].toDate(),
      contactNumber: map['contactNum'],
      amount: map['amount'],
    );
  }
}