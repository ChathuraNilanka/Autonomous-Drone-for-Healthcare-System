import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emedic/models/credit_card.dart';
import 'package:emedic/models/medical_history.dart';
import 'package:emedic/models/order.dart';
import 'package:emedic/models/payment.dart';
import 'package:emedic/resources/repository.dart';
import 'package:emedic/ui/order/order_list.dart';
import 'package:emedic/utils/common.dart';
import 'package:emedic/utils/credit_card_validator.dart';
import 'package:emedic/utils/enumeration.dart';
import 'package:emedic/utils/widgets/loading_widget.dart';
import 'package:emedic/utils/widgets/success_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class Checkout extends StatefulWidget {
  final MedicalHistory medicalHistory;
  final DocumentReference documentReference;
  final String amount;

  const Checkout({Key key, @required this.medicalHistory,@required this.documentReference, this.amount}) : super(key: key);

  @override
  _CheckoutState createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  GoogleMapController _controller;

  CameraPosition _kGooglePlex;
  LatLng _latLng;
  String _address;
  MarkerId _markerId = MarkerId("marker");
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  CreditCard _selectedCard;

  TextEditingController _cardNumberController = TextEditingController();
  TextEditingController _cardcsvController = TextEditingController();
  TextEditingController _cardmmController = TextEditingController();
  TextEditingController _cardyyController = TextEditingController();
  TextEditingController _cardPlaceholderController = TextEditingController();
  IconData _cardIcon = FontAwesomeIcons.creditCard;

  void _geCurrentLocation() async {
    Geolocator geolocator = Geolocator()..forceAndroidLocationManager = true;
    Position position = await geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks = await Geolocator()
        .placemarkFromCoordinates(position.latitude, position.longitude);
    LatLng latLng = LatLng(position.latitude, position.longitude);
    String address = "unknown";

    if (placemarks != null && placemarks.isNotEmpty) {
      address = _buildAddressString(placemarks.first);
    }
    Marker _marker = Marker(markerId: _markerId, position: latLng);
    if (mounted) {
      setState(() {
        _latLng = latLng;
        _address = address;
        _kGooglePlex = CameraPosition(
          target: latLng,
          zoom: 14.4746,
        );
        _markers[_markerId] = _marker;
      });
    }
  }

  static String _buildAddressString(Placemark placemark) {
    final String name = placemark.name ?? '';
    final String city = placemark.locality ?? '';
    final String country = placemark.country ?? '';

    return '$name, $city, $country';
  }

  @override
  void initState() {
    super.initState();
    _geCurrentLocation();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final iconColor = Colors.black54;
    final medicalHistory = widget.medicalHistory;
    final estimateTime = "15-25 min";
    final deliveryCharges = 60;
    return Scaffold(
      appBar: AppBar(
        title: Text(CheckoutPageText.appBar),
      ),
      body: _latLng == null
          ? Container(
              child: LoadingWidget(),
            )
          : Container(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              height: height * 0.2,
                              child: InkWell(
                                onTap: () async {
                                  LocationResult result =
                                      await showLocationPicker(
                                          context, MAPS_API_KEY,myLocationButtonEnabled: true,initialCenter: _latLng,automaticallyAnimateToCurrentLocation: true,requiredGPS: true);
                                  List<Placemark> placemarks =
                                      await Geolocator()
                                          .placemarkFromCoordinates(
                                              result.latLng.latitude,
                                              result.latLng.longitude);
                                  setState(() {
                                    _address =
                                        _buildAddressString(placemarks.first);
                                    _latLng = result.latLng;
                                    _markers[_markerId] = Marker(
                                        markerId: _markerId,
                                        position: result.latLng);
                                  });
                                  _controller.animateCamera(
                                      CameraUpdate.newCameraPosition(
                                          CameraPosition(
                                              target: result.latLng,
                                              zoom: 15)));
                                },
                                child: AbsorbPointer(
                                  absorbing: true,
                                  child: GoogleMap(
                                    mapType: MapType.normal,
                                    initialCameraPosition: _kGooglePlex,
//                padding: EdgeInsets.only(top: height*0.4,),
                                    onMapCreated:
                                        (GoogleMapController controller) {
                                      _controller = controller;
                                    },
                                    markers: Set<Marker>.of(_markers.values),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Text(
                              _address.split(",")[0],
                              style: textTheme.bodyText1
                                  .copyWith(fontSize: width * 0.043),
                            ),
                            Text(
                              _address,
                              style: textTheme.bodyText2
                                  .copyWith(fontSize: width * 0.035),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Divider(),
                            SizedBox(
                              height: 12,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  FontAwesomeIcons.clock,
                                  color: iconColor,
                                  size: 15,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "${CheckoutPageText.deliveryTime}: $estimateTime",
                                  style: textTheme.bodyText2,
                                )
                              ],
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Divider(),
                            SizedBox(
                              height: 12,
                            ),
                            Text(
                              CheckoutPageText.orderTitle,
                              style: textTheme.headline6,
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text(
                                    medicalHistory.prescription,
                                    style: textTheme.bodyText2
                                        .copyWith(fontSize: width * 0.04),
                                  ),
                                ),
                                Expanded(
                                    child: Container(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          "$CURRENCY ${widget.amount}",
                                          style: textTheme.bodyText2.copyWith(
                                              fontSize: width * 0.038),
                                        ))),
                              ],
                            ),
                            Text(
                              DateFormat("MMM dd, yyyy")
                                  .format(medicalHistory.createdAt),
                              style: textTheme.bodyText2
                                  .copyWith(fontSize: width * 0.033),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Divider(),
                            SizedBox(
                              height: 12,
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  CheckoutPageText.subTotal,
                                  style: textTheme.bodyText2
                                      .copyWith(fontSize: width * 0.035),
                                ),
                                Expanded(
                                    child: Container(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          "$CURRENCY ${widget.amount}",
                                          style: textTheme.bodyText2.copyWith(
                                              fontSize: width * 0.035),
                                        ))),
                              ],
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  CheckoutPageText.deliveryFee,
                                  style: textTheme.bodyText2
                                      .copyWith(fontSize: width * 0.035),
                                ),
                                Expanded(
                                    child: Container(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          "$CURRENCY $deliveryCharges",
                                          style: textTheme.bodyText2.copyWith(
                                              fontSize: width * 0.035),
                                        ))),
                              ],
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Row(
                              children: <Widget>[
                                Text(
                                  CheckoutPageText.total,
                                  style: textTheme.bodyText2.copyWith(
                                      fontSize: width * 0.035,
                                      fontWeight: FontWeight.bold),
                                ),
                                Expanded(
                                    child: Container(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          "$CURRENCY ${(double.parse(widget?.amount??"0")+ deliveryCharges)}",
                                          style: textTheme.bodyText2.copyWith(
                                              fontSize: width * 0.035,
                                              fontWeight: FontWeight.bold),
                                        ))),
                              ],
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Divider(),
                            _buildRow(textTheme)
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: double.maxFinite,
                    child: RaisedButton(
                      color: _selectedCard == null
                          ? Color(0xFF4caf50)
                          : Color(0xFF00c853),
                      elevation: 15,
                      onPressed: () => _paymentConfirmAlert(),
                      child: Text(
                        _selectedCard == null
                            ? CheckoutPageText.addPayment
                            : CheckoutPageText.placeOrder,
                        style: TextStyle(
                            color: Colors.white, fontSize: width * 0.04),
                      ),
                      padding: EdgeInsets.all(height * 0.025),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero),
                    ),
                  )
                ],
              ),
            ),
    );
  }

  Row _buildRow(TextTheme textTheme) {
    String cardType = CheckoutPageText.credit.toUpperCase();
    String cardNumber = CheckoutPageText.credit.toUpperCase();
    if (_selectedCard != null) {
      cardType = _selectedCard.cardType.toUpperCase();
      int length = _cardNumberController.text.length;

      cardNumber = "XX" + _cardNumberController.text.substring(length - 2);
    }

    return Row(
      children: <Widget>[
        Icon(
          _cardIcon,
          color: Colors.blueGrey,
        ),
        SizedBox(
          width: 10,
        ),
        Text(cardType, style: textTheme.bodyText1),
        Expanded(
          child: Container(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () => _addNewCard(),
                child: Card(
                    color: Color(0xFF00e676),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            cardNumber,
                            style: textTheme.bodyText1
                                .copyWith(color: Colors.white),
                          ),
                          Icon(
                            FontAwesomeIcons.chevronDown,
                            size: 12,
                            color: Colors.white,
                          )
                        ],
                      ),
                    )),
              )),
        )
      ],
    );
  }

  void _validateCard() {
    CreditCardValidator _validator =
        CreditCardValidator(_cardNumberController.text);

    CreditCardValidate valid = _validator.validate();
    String mm = _cardmmController.text;
    String yy = _cardyyController.text;
    String cardNo = _cardNumberController.text;
    String placeholder = _cardPlaceholderController.text;
    String csv = _cardcsvController.text;

    switch (valid) {
      case CreditCardValidate.invalid:
        _invalidAlert(CheckoutPageText.invalidCardTitle,
            CheckoutPageText.invalidCardcontent);
        return;
        break;
      case CreditCardValidate.empty:
        _invalidAlert(CheckoutPageText.emptyCardTitle,
            CheckoutPageText.invalidCardcontent);
        return;
        break;
      case CreditCardValidate.valid:
        if (placeholder.isEmpty || csv.isEmpty || mm.isEmpty || yy.isEmpty) {
          _invalidAlert(CheckoutPageText.invalidCardTitle,
              CheckoutPageText.invalidCardInformationcontent);
          return;
        }

        if (_validator.validaeExpiryDate(int.parse(mm), int.parse(yy))) {
          setState(() {
            _selectedCard = CreditCard(cardNo, csv, "$mm/$yy",
                enumToString(_validator.getType().toString()), placeholder);
          });
          Navigator.pop(context);
        } else {
          _invalidAlert(CheckoutPageText.invalidCardTitle,
              CheckoutPageText.invalidCardDatecontent);
          return;
        }
        break;
    }
  }

  void _invalidAlert(String title, String content) {
    if (_selectedCard != null)
      setState(() {
        _selectedCard = null;
      });
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(title),
              content: Text(content),
              actions: <Widget>[
                MaterialButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    CheckoutPageText.invalidCardOk,
                    style: TextStyle(color: Colors.pinkAccent),
                  ),
                ),
              ],
            ));
  }

  void _addNewCard() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Dialog(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 25,
                  ),
                  Container(
                      alignment: Alignment.center,
                      child: Text(
                        CheckoutPageText.addPayment,
                        style: Theme.of(context).textTheme.headline6,
                      )),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    child: TextField(
                      controller: _cardNumberController,
                      onChanged: (String cardNo) {
                        CreditCardValidator _cardValidator =
                            CreditCardValidator(cardNo);
                        CreditCardType cardType = _cardValidator.getType();
                        switch (cardType) {
                          case CreditCardType.masterCard:
                            _cardIcon = FontAwesomeIcons.ccMastercard;
                            break;
                          case CreditCardType.visa:
                            _cardIcon = FontAwesomeIcons.ccVisa;
                            break;
                          case CreditCardType.amex:
                            _cardIcon = FontAwesomeIcons.ccAmex;
                            break;
                          case CreditCardType.discover:
                            _cardIcon = FontAwesomeIcons.ccDiscover;
                            break;
                          case CreditCardType.jcb:
                            _cardIcon = FontAwesomeIcons.ccJcb;
                            break;
                          case CreditCardType.diners:
                            _cardIcon = FontAwesomeIcons.ccDinersClub;
                            break;
                          case CreditCardType.unknown:
                            _cardIcon = FontAwesomeIcons.creditCard;
                            break;
                        }
                        setState(() {});
                      },
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          _cardIcon,
                          color: Colors.blueGrey,
                        ),
                        labelText: CheckoutPageText.cardNumber,
                        border: UnderlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    child: TextField(
                      controller: _cardPlaceholderController,
                      decoration: InputDecoration(
                        suffixIcon: Icon(FontAwesomeIcons.idCard),
                        labelText: CheckoutPageText.cardPlaceHolder,
                        border: UnderlineInputBorder(),
                      ),
                      keyboardType: TextInputType.text,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    children: <Widget>[
                      Container(
                        width: 70,
                        child: TextField(
                          controller: _cardcsvController,
                          decoration: InputDecoration(
                            labelText: CheckoutPageText.csv,
                            border: UnderlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      Spacer(),
                      Container(
                        width: 40,
                        child: TextField(
                          controller: _cardmmController,
                          decoration: InputDecoration(
                            labelText: CheckoutPageText.mm,
                            border: UnderlineInputBorder(),
                            counter: Container(),
                          ),
                          maxLength: 2,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      SizedBox(
                        width: 15,
                      ),
                      Container(
                        width: 40,
                        child: TextField(
                          controller: _cardyyController,
                          maxLength: 2,
                          decoration: InputDecoration(
                            labelText: CheckoutPageText.yy,
                            border: UnderlineInputBorder(),
                            counter: Container(),
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: <Widget>[
                      Spacer(),
                      MaterialButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          CheckoutPageText.addCreditCardNo,
                          style: TextStyle(color: Colors.pinkAccent),
                        ),
                      ),
                      MaterialButton(
                        onPressed: () => _validateCard(),
                        child: Text(CheckoutPageText.addCreditCardYes,
                            style: TextStyle(color: Colors.green)),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _paymentConfirmAlert() {
    if (_selectedCard == null) {
      _addNewCard();
      return;
    }
//    Map paymentObject = {
//      "sandbox": true,                 // true if using Sandbox Merchant ID
//      "merchant_id": "1214029",        // Replace your Merchant ID
//      "merchant_secret": "4PXNkaRz77U4uVzpxZToDZ4uPXdGQAQoT4eblUzgMpDY",        // See step 4e
//      "notify_url": "www.google.com",
//      "order_id": "ItemNo12345",
//      "items": "Hello from Flutter!",
//      "amount": "50.00",
//      "currency": "LKR",
//      "first_name": "Saman",
//      "last_name": "Perera",
//      "email": "samanp@gmail.com",
//      "phone": "0771234567",
//      "address": "No.1, Galle Road",
//      "city": "Colombo",
//      "country": "Sri Lanka",
//      "delivery_address": "No. 46, Galle road, Kalutara South",
//      "delivery_city": "Kalutara",
//      "delivery_country": "Sri Lanka",
//      "custom_1": "",
//      "custom_2": ""
//    };

//    PayHere.startPayment(
//        paymentObject, (paymentId) {
//      print("One Time Payment Success. Payment Id: $paymentId");
//    }, (error) {
//      print("One Time Payment Failed. Error: $error");
//    }, () {
//      print("One Time Payment Dismissed");
//    }
//    );
//    return;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
          builder: (contexxt, setState) => AlertDialog(
                title: Text(
                  CheckoutPageText.paymentConfirmAlertTitle,
                  textAlign: TextAlign.center,
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      height: 100,
                      width: 100,
                      child: FlareActor(
                        "assets/flare/payment_pending.flr",
                        animation: "animate",
                        fit: BoxFit.contain,
                      ),
                    ),
                    Container(
                      child: Text(CheckoutPageText.paymentConfirmAlertContent),
                    )
                  ],
                ),
                actions: <Widget>[
                  MaterialButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      CheckoutPageText.paymentConfirmAlertNo,
                      style: TextStyle(color: Colors.pinkAccent),
                    ),
                  ),
                  MaterialButton(
                    onPressed: () => _placeOrder(),
                    child: Text(CheckoutPageText.paymentConfirmAlertYes,
                        style: TextStyle(color: Colors.green)),
                  ),
                ],
              )),
    );
  }

  void _placeOrder() async {
    Navigator.pop(context);
    showDialog(
        context: context,
        builder: (context) => Dialog(
              child: PleaseWait(),
            ),
        barrierDismissible: false);

    Repository _repository = Repository();
    FirebaseUser _user = await _repository.getCurrentFirebaseUser();
    final now = DateTime.now();
    final reference = widget.documentReference;
    reference.updateData({
      "orderStatus":enumToString(OrderStatus.paid.toString()),
      "location":GeoPoint(_latLng?.latitude??0,_latLng?.longitude??0)
    });
    Payment _payment = Payment(verify: false, createdAt: now, updatedAt: now);
    await reference.collection("payment").add(_payment.toMap());
    Navigator.pop(context);
    showDialog(
        context: context,
        builder: (context) => SuccessAlert(
              button: MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                  pushPage(context, OrderList());
                },
                child: Text(
                  CheckoutPageText.successOk,
                  style: TextStyle(color: Colors.pinkAccent),
                ),
              ),
              title: CheckoutPageText.successTitle,
              content: CheckoutPageText.successContent,
            ),
        barrierDismissible: false);
  }
}
