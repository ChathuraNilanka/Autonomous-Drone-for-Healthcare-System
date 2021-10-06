import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emedic/models/credit_card.dart';
import 'package:emedic/models/medical_history.dart';
import 'package:emedic/models/order.dart';
import 'package:emedic/models/payment.dart';
import 'package:emedic/models/user.dart';
import 'package:emedic/resources/repository.dart';
import 'package:emedic/ui/order/live_track.dart';
import 'package:emedic/ui/order/order_animation.dart';
import 'package:emedic/utils/common.dart';
import 'package:emedic/utils/credit_card_validator.dart';
import 'package:emedic/utils/enumeration.dart';
import 'package:emedic/utils/themes.dart';
import 'package:emedic/utils/widgets/AppRatingBar.dart';
import 'package:emedic/utils/widgets/app_scaffold.dart';
import 'package:emedic/utils/widgets/loading_widget.dart';
import 'package:emedic/utils/widgets/success_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

import 'checkout.dart';

class OrderList extends StatefulWidget {
  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  Repository _repository = Repository();
  TextEditingController _cardNumberController = TextEditingController();
  TextEditingController _cardcsvController = TextEditingController();
  TextEditingController _cardmmController = TextEditingController();
  TextEditingController _cardyyController = TextEditingController();
  TextEditingController _cardPlaceholderController = TextEditingController();
  IconData _cardIcon = FontAwesomeIcons.creditCard;
  CreditCard _selectedCard;
  FirebaseUser _user;
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.currentUser().then((value){
      setState(() {
        _user = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      page: DrawerPages.OrderList,
      child: Container(
        color: backgroundColor,
        child: StreamBuilder(
          stream: _repository.getAllOrders(_user?.uid),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) return LoadingWidget();
            return SingleChildScrollView(child: Container(
                child: _buildList(snapshot.data.documents)));
          },
        ),
      ),
    );
  }

  ListView _buildList(List<DocumentSnapshot> documents) {
    return ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: documents.length,
      itemBuilder: (BuildContext context, int index) {
        Order order = Order.fromMap(documents[index].data);
        order.id = documents[index].documentID;
        return _listItem(order, documents[index].reference);
      },
    );
  }

  String _getOrderStatus(OrderStatus orderStatus) {
    switch (orderStatus) {
      case OrderStatus.waiting:
        return OrderListPageText.orderAwait;
        break;
      case OrderStatus.paid:
        return OrderListPageText.orderPacking;
        break;
      case OrderStatus.accepted:
        return OrderListPageText.orderPaid;
        break;
      case OrderStatus.onTheWay:
        return OrderListPageText.orderOnTheWay;
        break;
      case OrderStatus.completed:
        return OrderListPageText.orderDeliverd;
        break;
      case OrderStatus.cancelled:
        return OrderListPageText.orderCanceled;
        break;
    }
    return "";
  }

  Widget _listItem(Order order, DocumentReference documentReference) {
    final textTheme = Theme.of(context).textTheme;
    final width = MediaQuery.of(context).size.width;
    final orderStatus = stringToOrderStatus(order.orderStatus);
    IconData _icon;
    if (orderStatus == OrderStatus.completed)
      _icon = FontAwesomeIcons.checkCircle;
    else if (orderStatus == OrderStatus.cancelled)
      _icon = FontAwesomeIcons.minus;
    else
      _icon = FontAwesomeIcons.spinner;
    final pay = stringToPrescriptionType(order.prescriptionType) == PrescriptionType.handWritten && orderStatus == OrderStatus.accepted;
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15)
      ),
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(2),
              height: 150,
              child: OrderAnimation(
                drone: order.liveTrack,
                location: order.location,
                orderStatus: orderStatus,
              ),
            ),
            Divider(),
            Row(
              children: <Widget>[
                Icon(
                  _icon,
                  size: width * 0.03,
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                    child: Text(
                  _getOrderStatus(orderStatus),
                  style: textTheme.headline6.copyWith(fontSize: width * 0.04),
                )),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: <Widget>[
                Icon(
                  FontAwesomeIcons.calendarDay,
                  size: width * 0.03,
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                    child: Text(DateFormat("MMM dd, yyyy hh:mm a")
                        .format(order.updatedAt))),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: <Widget>[
                Icon(
                  FontAwesomeIcons.fingerprint,
                  size: width * 0.03,
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(child: Text(order.id)),
              ],
            ),
            Divider(),
            FutureBuilder(
              future: _repository.getMedicalHistoryByID(
                  order.referecnceId, order.userId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Container();
                MedicalHistory medicalHistory = snapshot.data;
                return Container(
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(
                            FontAwesomeIcons.pills,
                            size: width * 0.03,
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Expanded(child: Text(medicalHistory.prescription)),
                        ],
                      ),
                      SizedBox(height: 5,),
                      Row(
                        children: <Widget>[
                          Icon(
                            FontAwesomeIcons.userMd,
                            size: width * 0.03,
                          ),
                          SizedBox(
                            width: 12,
                          ),
                          Expanded(child: Text("Dr. ${medicalHistory.docName}")),
                        ],
                      ),
                      SizedBox(height: 15,),
                      orderStatus == OrderStatus.completed?AppRatingBar(documentReference: documentReference,):Container(),
                      orderStatus == OrderStatus.waiting?Container():Row(
                        children: <Widget>[
                          Expanded(
                            child: MaterialButton(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                              onPressed: () {
                                if(pay)
                                 _addNewCard(order);
                                else{
                                  if(stringToPrescriptionType(order.prescriptionType)==PrescriptionType.handWritten)
                                    if(orderStatus == OrderStatus.waiting)
                                      return;
                                    _showReceipt(medicalHistory,order);
                                }
                              },
                              child: Text(pay? OrderListPageText.pay : OrderListPageText.viewReceipt),
                              textColor: pay? Colors.green:Theme.of(context).primaryColor,
                            ),
                          ),
                          orderStatus == OrderStatus.accepted?
                          Expanded(
                            child: MaterialButton(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                              onPressed: ()async{
                                PermissionStatus permission =
                                    await PermissionHandler()
                                    .checkPermissionStatus(
                                    PermissionGroup.location);
                                await PermissionHandler().requestPermissions(
                                    [PermissionGroup.location]);

                                permission = await PermissionHandler()
                                    .checkPermissionStatus(
                                    PermissionGroup.location);

                                if (permission == PermissionStatus.granted) {
                                  pushPage(context,
                                      Checkout(medicalHistory: medicalHistory,documentReference: documentReference,amount: order?.amount?.toString() ?? medicalHistory?.amount?.toString()??"1000.00",));
                                } else {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: Text(
                                            TabsText.locationPermissionTitle),
                                        content: Text(TabsText
                                            .locationPermissionDescription),
                                        actions: <Widget>[
                                          MaterialButton(
                                            onPressed: () async {
                                              await PermissionHandler()
                                                  .openAppSettings();
                                              Navigator.pop(context);
                                            },
                                            child: Text("ok"),
                                            splashColor: Colors.transparent,
                                            highlightColor:
                                            Colors.transparent,
                                          )
                                        ],
                                      ));
                                }
                              },
                              child: Text(TabsText.customerConfirmationButton),
                              textColor: Colors.green,
                            ),
                          )
                              :Container(),
                          orderStatus == OrderStatus.onTheWay?
                              Expanded(
                                child: MaterialButton(
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                                  onPressed: (){
                                    pushPage(context,LiveTrack(order: documentReference,));
                                  },
                                  child: Text(OrderListPageText.track),
                                  textColor: Colors.green,
                                ),
                              )
                              :Container()
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showReceipt(MedicalHistory medicalHistory,Order order){
    showDialog(context: context,
    builder: (context)=> AlertDialog(
      title: Text(OrderListPageText.receipt,textAlign: TextAlign.center,),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(CheckoutPageText.subTotal),
              Spacer(),
              Text(order?.amount?.toString()??medicalHistory?.amount?.toString()??"1000.00"),
            ],
          ),
          SizedBox(height: 5,),
          Row(
            children: <Widget>[
              Text(CheckoutPageText.deliveryFee),
              Spacer(),
              Text("60.00"),
            ],
          ),
          SizedBox(height: 5,),
          Divider(),
          SizedBox(height: 15,),
          Row(
            children: <Widget>[
              Text(CheckoutPageText.total),
              Spacer(),
              Text((double.parse(order?.amount?.toString()??"0.0")+60).toString()),
            ],
          ),
        ],
      ),
      actions: <Widget>[
        MaterialButton(
          onPressed: () => Navigator.pop(context),
          child: Text(
            OrderListPageText.close,
            style: TextStyle(color: Colors.pinkAccent),
          ),
        ),
      ],
    ));
  }

  void _addNewCard(Order order) {
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
                        onPressed: () => _pay(order),
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

  Future<void> _pay(Order order) async {
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
          showDialog(context: context,barrierDismissible: false,builder: (context)=>Dialog(child: PleaseWait()));
          Payment payment = Payment(
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            verify: true
          );
          await _repository.updatePayment(order.id, payment);
          Navigator.pop(context);
          showDialog(context: context,barrierDismissible: false,builder: (context)=>SuccessAlert(
            button:  MaterialButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                OrderListPageText.close,
                style: TextStyle(color: Colors.pinkAccent),
              ),
            ),
            title: OrderListPageText.successTitle,
            content: OrderListPageText.successContent,
          ));
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
}
