import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emedic/models/order.dart';
import 'package:emedic/models/payment.dart';
import 'package:emedic/utils/enumeration.dart';

class OrderProvider{
  final _collectionName = "order";
  final _paymentCollectionName = "payment";
  Firestore _firestore = Firestore.instance;

  Future<DocumentReference> placeAnOrder(Order _order,{Payment payment})async{
    DocumentReference reference = await _firestore.collection(_collectionName).add(_order.toMap());
    if(payment != null)
      await reference.collection(_paymentCollectionName).add(payment.toMap());
    return reference;
  }
  Stream<QuerySnapshot> getAllOrders(String uid){
    return _firestore.collection(_collectionName).where("patientId",isEqualTo: uid??"")
        .orderBy("updatedAt",descending: true)
        .snapshots();
  }
  
  Future<void> updatePayment(String orderID,Payment _payment)async{
    await _firestore.collection(_collectionName).document(orderID).updateData({"orderStatus":enumToString(OrderStatus.onTheWay.toString())});
    await _firestore.collection(_collectionName).document(orderID).collection(_paymentCollectionName).document().setData(_payment.toMap());
  }

  Future<void> updateOrderRating(DocumentReference reference,double value)async{
    return await reference.updateData({
      "rating": value
    });
  }

}