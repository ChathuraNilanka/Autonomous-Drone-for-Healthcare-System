import 'package:flutter/foundation.dart';
class User{
  String id;
  String fullName;
  String name;
  String displayName;
  String email;
  String nic;
  String mobileNumber;
  String gender;
  DateTime birthday;
  DateTime createdAt;
  DateTime updatedAt;
  bool active;
  bool authenticationEnabled;

  static final User _user = User._internal();

  factory User(){
    return _user;
  }
  User._internal();

  User.named({
    @required this.id,
    @required this.fullName,
    @required this.name,
    @required this.displayName,
    @required this.email,
    @required this.nic,
    @required this.mobileNumber,
    @required this.gender,
    @required this.birthday,
    @required this.createdAt,
    @required this.updatedAt,
    @required this.active,
    this.authenticationEnabled = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': this.id,
      'fullName': this.fullName,
      'name': this.name,
      'displayName': this.displayName,
      'email': this.email,
      'nic': this.nic,
      'mobileNumber': this.mobileNumber,
      'gender': this.gender,
      'birthday': this.birthday,
      'createdAt': this.createdAt,
      'updatedAt': DateTime.now(),
      'active':true,
      "authenticationEnabled":this.authenticationEnabled
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User.named(
      id: map['id'] as String,
      fullName: map['fullName'] as String,
      name: map['name'] as String,
      displayName: map['displayName'] as String,
      email: map['email'] as String,
      nic: map['nic'] as String,
      mobileNumber: map['mobileNumber'] as String,
      gender: map['gender'] as String,
      birthday: map['birthday'].toDate(),
      createdAt: map['createdAt'].toDate(),
      updatedAt: map['updatedAt'].toDate(),
      active: map['active'] as bool,
      authenticationEnabled: map['authenticationEnabled'] as bool,
    );
  }
}