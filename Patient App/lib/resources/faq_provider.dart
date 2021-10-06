import 'package:cloud_firestore/cloud_firestore.dart';

class FAQProvider{
  final _collectionName = "faq";
  Firestore _firestore = Firestore.instance;

  Future<QuerySnapshot> getFAQs()async{
    return await _firestore.collection(_collectionName).orderBy("id",descending: false).getDocuments();
  }
  Future<QuerySnapshot> searchFAQs(String keyword)async{
    return await _firestore.collection(_collectionName)
    .orderBy("question")
        .startAt([keyword])
    .endAt([keyword+ '\uf8ff'])
        .getDocuments();
  }
}