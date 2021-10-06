import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emedic/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserProvider{
  final _collectionName = "patients";
  Firestore _firestore = Firestore.instance;

  Future<void> registerUser(String uid)async{
    return _firestore.collection(_collectionName).document(uid).setData(User().toMap());
  }
  Future<void> updateAuthentication(String uid)async{
    return _firestore.collection(_collectionName).document(uid).updateData({
      "authenticationEnabled":true
    });
  }

  Future<bool> isUser(String uid)async{
    final result = await _firestore
        .collection(_collectionName)
        .document(uid).get();
    return result.data != null;
  }
  Future<User> getUser(String uid)async{
    final result = await _firestore
        .collection(_collectionName)
        .document(uid).get();
    return User.fromMap(result.data);
  }

  Future<FirebaseUser> getCurrentFirebaseUser()async{
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    return firebaseAuth.currentUser();
  }

  Future<bool> isAlreadyRegisteredMobileNumber(String mobileNumber)async{
    final result = await _firestore
        .collection(_collectionName)
    .where("mobileNumber",isEqualTo: mobileNumber)
    .getDocuments();
    
    return result.documents.length != 0;
  }

}