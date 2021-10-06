import 'package:flutter/foundation.dart';

class ChatModel {
  String userId;
  String text;
  bool send;
  DateTime createdAt;


  Map<String, dynamic> toMap() {
    return {
      'userId': this.userId,
      'text': this.text,
      'send': this.send,
      'createdAt': this.createdAt,
    };
  }

  factory ChatModel.fromMap(Map<String, dynamic> map) {
    return new ChatModel(
      userId: map['userId'] as String,
      text: map['text'] as String,
      send: map['send'] as bool,
      createdAt: map['createdAt'].toDate(),
    );
  }

  ChatModel({
    @required this.userId,
    @required this.text,
    @required this.send,
    @required this.createdAt,
  });
}
