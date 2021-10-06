enum CreditCardValidate{ invalid,empty,valid }
enum CreditCardType{masterCard,visa,amex,discover,jcb,diners,unknown}

enum OrderStatus{waiting,accepted,onTheWay,completed,cancelled,paid}
enum PrescriptionType{online,handWritten}

enum DrawerPages{Home,MedicalHistory,OrderList,cameraUpload,faq,settings,chat,doctors}

OrderStatus stringToOrderStatus(String string){
  switch(string){
    case "waiting":
      return OrderStatus.waiting;
    case "paid":
      return OrderStatus.paid;
    case "accepted":
      return OrderStatus.accepted;
    case "onTheWay":
      return OrderStatus.onTheWay;
    case "completed":
      return OrderStatus.completed;
  }
  return OrderStatus.cancelled;
}

PrescriptionType stringToPrescriptionType(String string){
  switch(string){
    case "online":
      return PrescriptionType.online;
    default:
      return PrescriptionType.handWritten;
  }

}

CreditCardType stringToCreditCardType(String string){
  switch (string){
    case "masterCard":
      return CreditCardType.masterCard;
    case "visa":
      return CreditCardType.visa;
    case "amex":
      return CreditCardType.amex;
    case "discover":
      return CreditCardType.discover;
    case "jcb":
      return CreditCardType.jcb;
    case "diners":
      return CreditCardType.diners;
    default:
      return CreditCardType.unknown;
  }
}

String enumToString(String string){
  return string.split(".")[1];
}