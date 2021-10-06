import 'dart:io' show Platform;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DeviceInfoProvider {
  final _collection = "notification";
  final _firestore = Firestore.instance;

  Future<void> saveToken(String token) async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    final documentReference =
        _firestore.collection(_collection).document(user.uid);
    String platform = Platform.isAndroid ? "android" : "ios";
    return documentReference.setData({"token": token, "platform": platform});
  }

  Future<String> getSavedToken() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final documentReference =
        await _firestore.collection(_collection).document(user.uid).get();

    if (!documentReference.exists)
      return null;
    else {
      return documentReference.data["token"];
    }
  }
}
