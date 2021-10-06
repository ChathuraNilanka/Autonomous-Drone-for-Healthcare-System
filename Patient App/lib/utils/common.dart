import 'package:emedic/utils/enumeration.dart';
import 'package:flutter/material.dart';

const APP_NAME = "eMedic";
const MAPS_API_KEY = "AIzaSyBAMBxfRBZO3BZu1GMUEEEDkQnTH7DAAgs";
const CURRENCY = "LKR";

Future<dynamic> pushPage(BuildContext context,Widget page){
  return Navigator.push(context, MaterialPageRoute(
      builder: (context)=>page
  ));
}
Future<dynamic> pushReplaced(BuildContext context,Widget page){
  return Navigator.pushReplacement(context, MaterialPageRoute(
      builder: (context)=>page
  ));
}

class Common{
  static String displayName;
  static String profilePicture;
  static String facialServer;
  static String droneServer;
}

class AuthPageText{
  static final greeting = "Autonomus medicine delivery";
  static final signUpButton = "Hi, eMedic!";
  static final loginButton = "I already have an account";
}
class LoginPageText{
  static final title = "Mobile Number";
  static final description = "Enter your phone number, we will send you to an OTP code";
  static final phoneNumberHint = "Enter Mobile Phone Number";
  static final loginButton = "Signin";
}

class OTPVerificationPageText{
  static final title = "Enter Code";
  static final hint = "Enter OTP Code";
  static final description = "We have sent a text message with a 6 digits verification code to";
  static final verifyButton = "Verify";
}

class SignUpPageText{
  static final title = "Nice to meet you.! Let me give some details about you";

  static final fullName = "Full Name";
  static final fullNameDescription = "Enter your Full Name";
  static final fullNameRequired = "valid full name is required";

  static final nameWithInitials = "Name with Initials";
  static final nameWithInitialsDescription = "Enter your Name with Initials";
  static final nameWithInitialsRequired = "Valid name with initials is required";

  static final displayName = "Display Name";
  static final displayNameDescription = "Enter your Display Name";
  static final displayNameRequired = "Valid display name is required";

  static final nic = "NIC Number";
  static final nicDescription = "Enter your NIC Number";
  static final nicRequired = "Valid NIC number is required";

  static final birthday = "Birthday";
  static final birthdayDescription = "Pick your Birthday";

  static final email = "Email Address";
  static final emailDescription = "Enter your Email Address";
  static final emailRequired = "Valid Email Address is required";

  static final signUpButton = "Continue";
}
class CheckoutPageText{
  static final appBar = "Checkout";
  static final deliveryTime = "Delivery Time";
  static final orderTitle = "Your Order";
  static final subTotal = "Subtotal";
  static final deliveryFee = "Delivery Fee";
  static final total = "Total";
  static final credit = "Credit Card";
  static final placeOrder = "Place Order";
  static final addPayment = "Add Credit Card Details";
  static final paymentConfirmAlertTitle = "Confirm Payment";
  static final paymentConfirmAlertContent = "Please make sure this information is corrct before place the order";
  static final paymentConfirmAlertYes = "Yes!";
  static final paymentConfirmAlertNo = "Wait! I forgot Something";
  static final addCreditCardTitle = "Add New Credit Card";
  static final cardNumber = "Card Number";
  static final cardPlaceHolder = "Placeholder";
  static final csv = "CSV";
  static final mm = "MM";
  static final yy = "YY";
  static final addCreditCardYes = "Done";
  static final addCreditCardNo = "Cancel";
  static final emptyCardTitle = "Credit Card Number is Required";
  static final invalidCardTitle = "Invalid Card Information";
  static final invalidCardcontent = "Credit card verification failed.Please check your card number and try again";
  static final invalidCardDatecontent = "Credit card verification failed.Please check your card expiry date and try again";
  static final invalidCardInformationcontent = "Credit card verification failed.Please check your card information and try again";
  static final invalidCardOk = "Okay";
  static final successTitle = "Order Complete";
  static final successContent = "Your order has been successfully placed. Please wait for pharmacy result.";
  static final successOk = "Okay";
}
class TabsText{
  static final orderButton = "Order";
  static final customerConfirmationButton = "Order Confirmation";
  static final locationPermissionTitle = "Location permmission is required";
  static final locationPermissionDescription= "$APP_NAME requires location permission for make an order";
}
class OrderAnimationPageText{
  static final orderCanceled = "Cancelled";
  static final droneLogo = "logo.png";
}
class OrderListPageText{
  static final orderCanceled = "Order Cancelled";
  static final orderAwait = "Awaiting Confirmation from Pharmacy";
  static final orderPaid = "Awaiting Confirmation from customer";
  static final orderDeliverd = "Order Delivered";
  static final orderOnTheWay = "Your order is on the way";
  static final orderPacking= "We are working on your order";
  static final viewReceipt= "View Receipt";
  static final pay= "PAY";
  static final track= "Track";
  static final receipt= "Receipt";
  static final close = "Close";
  static final successTitle = "Payment Complete";
  static final successContent = "Your payment successfully completed.Please wait for the package";
}
class PageTitles{
  static final home = "Home";
  static final orders = "Orders";
  static final medicalHistory = "Orders";
  static final uploadPrescription = "Upload Prescription";
  static final faq = "FAQ";
  static final settings = "Settings";
  static final chat = "Chat";
  static final doctor = "myDoctors";
}
class SettingsPageText{
  static final settings = "Settings";
  static final signout = "Signout";
  static final info = "Info";
  static final email = "Email";
  static final fullName = "Full Name";
  static final displayName = "Display Name";
  static final mobileNumber = "Mobile Number";
}
class UploadPrescriptionPageText{
  static final button = "Upload";
  static final camera = "Camera";
  static final gallery = "Gallery";
}

class HeroText{
  static final heroLogo = "logo";
  static final heroAppName = "app_name";
}

class SoS{
  static String sosTitle;
  static String sosLink;
  static String sosSubtitle;
}
