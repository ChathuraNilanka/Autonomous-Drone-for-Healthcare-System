import 'enumeration.dart';

class CreditCardValidator{
  String _cardNumber;

  CreditCardValidator(this._cardNumber);

  CreditCardValidate validate() {

    if (_cardNumber.isEmpty) {
      return CreditCardValidate.empty;
    }

    if (_cardNumber.length < 8) { // No need to even proceed with the validation if it's less than 8 characters
      return CreditCardValidate.invalid;
    }

    int sum = 0;
    int length = _cardNumber.length;
    for (var i = 0; i < length; i++) {
      // get digits in reverse order
      int digit = int.parse(_cardNumber[length - i - 1]);

      // every 2nd number multiply with 2
      if (i % 2 == 1) {
        digit *= 2;
      }
      sum += digit > 9 ? (digit - 9) : digit;
    }

    return sum % 10 == 0? CreditCardValidate.valid: CreditCardValidate.invalid;
  }

  CreditCardType getType(){
    final visa = RegExp(r'^4[0-9]{6,}$');
    final master = RegExp(r'^5[1-5][0-9]{5,}|222[1-9][0-9]{3,}|22[3-9][0-9]{4,}|2[3-6][0-9]{5,}|27[01][0-9]{4,}|2720[0-9]{3,}$');
    final american= RegExp(r'^3[47][0-9]{5,}$');
    final discover = RegExp(r'^6(?:011|5[0-9]{2})[0-9]{3,}$');
    final jcb = RegExp(r'^(?:2131|1800|35[0-9]{3})[0-9]{3,}$');
    final diners = RegExp(r'^3(?:0[0-5]|[68][0-9])[0-9]{4,}$');

    if(visa.hasMatch(_cardNumber))
      return CreditCardType.visa;
    else if(master.hasMatch(_cardNumber))
      return CreditCardType.masterCard;
    else if(american.hasMatch(_cardNumber))
      return CreditCardType.amex;
    else if(discover.hasMatch(_cardNumber))
      return CreditCardType.discover;
    else if(jcb.hasMatch(_cardNumber))
      return CreditCardType.jcb;
    else if(diners.hasMatch(_cardNumber))
      return CreditCardType.diners;
    else
      return CreditCardType.unknown;
  }

  bool validaeExpiryDate(int cmonth,int cyear){
    DateTime now = DateTime.now();
    int year = now.year - 2000;
    int month = now.month;
    if(year> cyear)
      return false;
    else if (year== cyear){
      if(month<=cmonth)
        return true;
    }
    else if(year<cyear)
      return true;

    return false;
  }
}