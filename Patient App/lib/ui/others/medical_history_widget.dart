import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emedic/models/medical_history.dart';
import 'package:emedic/models/order.dart';
import 'package:emedic/resources/repository.dart';
import 'package:emedic/ui/facial_recognizer/recognize_face.dart';
import 'package:emedic/ui/order/checkout.dart';
import 'package:emedic/ui/order/order_list.dart';
import 'package:emedic/ui/others/notification_messages.dart';
import 'package:emedic/utils/common.dart';
import 'package:emedic/utils/enumeration.dart';
import 'package:emedic/utils/themes.dart';
import 'package:emedic/utils/widgets/loading_widget.dart';
import 'package:emedic/utils/widgets/success_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class MedicalHistoryWidget extends StatefulWidget {
  @override
  _MedicalHistoryWidgetState createState() => _MedicalHistoryWidgetState();
}

class _MedicalHistoryWidgetState extends State<MedicalHistoryWidget> {
  Repository _repository = Repository();
  FirebaseUser _user;

  @override
  void initState() {
    super.initState();
    _initState();
  }

  void _initState() async {
    FirebaseUser user = await _repository.getCurrentFirebaseUser();
    setState(() {
      _user = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_user == null) return LoadingWidget();

    return Container(
      color: backgroundColor,
      child: StreamBuilder(
          stream: _repository.getMedicalHistory(_user.uid),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return LoadingWidget();
            }
            return _buildListView(snapshot.data.documents);
          }),
    );
  }

  Widget _buildListView(List<DocumentSnapshot> _list) {
    return ListView.builder(
      itemCount: _list.length,
      itemBuilder: (BuildContext context, int index) {
        MedicalHistory medicalHistory =
            MedicalHistory.fromMap(_list[index].data);
        medicalHistory.id = _list[index].documentID;
        return _listItem(medicalHistory);
      },
    );
  }

  Widget _listItem(MedicalHistory medicalHistory) {
    final width = MediaQuery.of(context).size.width;
    final _primaryIconColor = Colors.black87;
    final _secondaryIconColor = Colors.black54;
    final _primaryTextColor = Colors.black87;
    final _secondaryTextColor = Colors.black54;
    final _primaryTextStyle =
        TextStyle(color: _primaryTextColor, fontSize: width * 0.042);
    final _secondaryTextStyle =
        TextStyle(color: _secondaryTextColor, fontSize: width * 0.035);

    return Container(
      padding: const EdgeInsets.all(5),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.info,
                    color: _primaryIconColor,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "${medicalHistory?.description??" "}",
                          style: _primaryTextStyle,
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Divider(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.userMd,
                    color: _secondaryIconColor,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "${medicalHistory?.docName ??" "}",
                        style: _primaryTextStyle,
                      ),
                    ],
                  )
                ],
              ),
              Divider(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.pills,
                    color: _secondaryIconColor,
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(medicalHistory?.prescription??" ",
                            style: _primaryTextStyle),
                        Text(
                          "${DateFormat("MMM dd, yyyy").format(medicalHistory.createdAt)}",
                          style: _secondaryTextStyle.copyWith(
                              fontSize: width * 0.03),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              Divider(),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      "Total: $CURRENCY ${medicalHistory?.amount ?? "N/A"}",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  medicalHistory.repeat
                     &&  medicalHistory.status != "ordered"
                      ? Center(
                          child: RaisedButton(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0)),
                            color: Colors.green,
                            padding: EdgeInsets.all(3),
                            child: Text(TabsText.orderButton.toUpperCase()),
                            onPressed: () async {
                              Repository _repository = Repository();
                              FirebaseUser _user = await _repository.getCurrentFirebaseUser();
                              final now = DateTime.now();
                              Order _order = Order(
                                  prescription: medicalHistory.prescription,
contactNumber: _user.phoneNumber,
//                                  location: _latLng,
                                  referecnceId: medicalHistory.id,
                                  orderStatus: enumToString(OrderStatus.waiting.toString()),
                                  prescriptionType: enumToString(PrescriptionType.online.toString()),
                                  userId: _user.uid,
                                  doctorName: medicalHistory.docName,
                                  doctorId: medicalHistory.docId,
                                  patientName: medicalHistory.patientName,
                                  createdAt: now,
                                  updatedAt: now);
                              await _repository.placeOrder(_order);
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
                              return;


//                              PermissionStatus permission =
//                                  await PermissionHandler()
//                                      .checkPermissionStatus(
//                                          PermissionGroup.location);
//                              await PermissionHandler().requestPermissions(
//                                  [PermissionGroup.location]);
//
//                              permission = await PermissionHandler()
//                                  .checkPermissionStatus(
//                                      PermissionGroup.location);
//
//                              if (permission == PermissionStatus.granted) {
//                                pushPage(context,
//                                    Checkout(medicalHistory: medicalHistory));
//                              } else {
//                                showDialog(
//                                    context: context,
//                                    builder: (context) => AlertDialog(
//                                          title: Text(
//                                              TabsText.locationPermissionTitle),
//                                          content: Text(TabsText
//                                              .locationPermissionDescription),
//                                          actions: <Widget>[
//                                            MaterialButton(
//                                              onPressed: () async {
//                                                await PermissionHandler()
//                                                    .openAppSettings();
//                                                Navigator.pop(context);
//                                              },
//                                              child: Text("ok"),
//                                              splashColor: Colors.transparent,
//                                              highlightColor:
//                                                  Colors.transparent,
//                                            )
//                                          ],
//                                        ));
//                              }
                            },
                          ),
                        )
                      : Container(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
