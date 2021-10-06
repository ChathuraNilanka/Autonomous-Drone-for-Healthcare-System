import 'package:flutter/foundation.dart';

class FAQModel{
  String question;
  String id;
  String answer;

  FAQModel({
    @required this.question,
    @required this.id,
    @required this.answer,
  });

  factory FAQModel.fromMap(Map<String, dynamic> map) {
    return new FAQModel(
      question: map['question'] as String,
      id: map['id'] as String,
      answer: map['answer'] as String,
    );
  }
}