import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emedic/models/chat_model.dart';
import 'package:emedic/models/user.dart';

class ChatProvider {
  final _collection = "chat";
  final _firestore = Firestore.instance;

  Future<void> addChat(ChatModel model) async {
    await _firestore.collection(_collection).document().setData(model.toMap());
  }

  Stream<QuerySnapshot> getChat() {
    String user = User().id;
    return _firestore
        .collection(_collection)
        .where("userId", isEqualTo: user)
        .orderBy("createdAt", descending: true)
        .snapshots();
  }
}
