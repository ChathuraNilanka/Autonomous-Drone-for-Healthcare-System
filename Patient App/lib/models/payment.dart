import 'package:flutter/foundation.dart';
class Payment{
  bool verify;
  DateTime createdAt;
  DateTime updatedAt;

  Payment({
    @required this.verify,
    @required this.createdAt,
    @required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'verify': this.verify,
      'createdAt': this.createdAt,
      'updatedAt': this.updatedAt,
    };
  }

  factory Payment.fromMap(Map<String, dynamic> map) {
    return new Payment(
      verify: map['verify'] as bool,
      createdAt: map['createdAt'] as DateTime,
      updatedAt: map['updatedAt'] as DateTime,
    );
  }
}