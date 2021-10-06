import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emedic/models/chat_model.dart';
import 'package:emedic/models/medical_history.dart';
import 'package:emedic/models/order.dart';
import 'package:emedic/models/payment.dart';
import 'package:emedic/models/user.dart';
import 'package:emedic/resources/chat_provider.dart';
import 'package:emedic/resources/device_info_provider.dart';
import 'package:emedic/resources/faq_provider.dart';
import 'package:emedic/resources/medical_provider.dart';
import 'package:emedic/resources/order_provider.dart';
import 'package:emedic/resources/prescription_storage_provider.dart';
import 'package:emedic/resources/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Repository {
  final _userProvider = UserProvider();
  final _medicalProvider = MedicalProvider();
  final _orderProvider = OrderProvider();
  final _uploadPrescription = PrescriptionStorageProvider();
  final _faqProvider = FAQProvider();
  final _chatProvider = ChatProvider();
  final _deviceInfoProvider = DeviceInfoProvider();

  Future<bool> isUser(String uid) => _userProvider.isUser(uid);
  Future<User> getUser(String uid) => _userProvider.getUser(uid);
  Future<bool> isAlreadyRegisteredMobileNumber(String mobileNumber) =>
      _userProvider.isAlreadyRegisteredMobileNumber(mobileNumber);
  Future<void> registerUser(String uid) => _userProvider.registerUser(uid);
  Future<FirebaseUser> getCurrentFirebaseUser() =>
      _userProvider.getCurrentFirebaseUser();

  Future<void> setMedicalHistory(MedicalHistory medicalHistory) =>
      _medicalProvider.setMedicalData(medicalHistory);
  Future<MedicalHistory> getMedicalHistoryByID(String id, String uid) =>
      _medicalProvider.getMedicalHistoryByID(id, uid);
  Stream<QuerySnapshot> getMedicalHistory(String uid) =>
      _medicalProvider.getMedicalData(uid);

  Future<DocumentReference> placeOrder(Order _order, {Payment payment}) =>
      _orderProvider.placeAnOrder(_order,payment: payment);
  Stream<QuerySnapshot> getAllOrders(String uid) =>
      _orderProvider.getAllOrders(uid);
  Future<void> updatePayment(String orderId, Payment payment) =>
      _orderProvider.updatePayment(orderId, payment);
  Future<void> updateOrderRating(DocumentReference reference, double rating) =>
      _orderProvider.updateOrderRating(reference, rating);

  Future<void> updatePrescriptionCollection(
          DateTime now, String path, String uid) =>
      _uploadPrescription.updatePrescriptionCollection(now, path, uid);

  Future<QuerySnapshot> getAllFAQs() => _faqProvider.getFAQs();
  Future<QuerySnapshot> searchFAQs(String keyword) =>
      _faqProvider.searchFAQs(keyword);

  Future<void> addMessage(ChatModel chat) => _chatProvider.addChat(chat);
  Stream<QuerySnapshot> getMessage() => _chatProvider.getChat();

  Future<void> saveDeviceToken(String token) =>
      _deviceInfoProvider.saveToken(token);
  Future<String> getDeviceToken() => _deviceInfoProvider.getSavedToken();
}
