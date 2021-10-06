import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:emedic/ui/facial_recognizer/recognize_face.dart';
import 'package:emedic/utils/common.dart';
import 'package:emedic/utils/enumeration.dart';
import 'package:emedic/utils/size_config.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NotificationMessage {
  final BuildContext context;

  NotificationMessage(this.context);

  Future<void> showRequestNotification(String title,String body,String documentId,String doctorId) async{
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
              title: Center(child: Text(title)),
              content: Text(body),
              actions: [
                MaterialButton(
                  child: Text(
                    "Reject",
                    style: TextStyle(color: Colors.pinkAccent),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                MaterialButton(
                    child: Text("Agree", style: TextStyle(color: Colors.green)),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RecognizeFace(doctorId: doctorId,documentId: documentId,)));
                    })
              ],
            ));
  }
  Future<void> showNormalNotification(String title,String body) async{
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
              title: Center(child: Text(title)),
              content: Text(body),
              actions: [
                MaterialButton(
                  child: Text(
                    "Okay",
                    style: TextStyle(color: Colors.pinkAccent),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ));
  }
  Future<void> showArrivalNotification(String title,String body,String id,String droneId) async{
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
              title: Center(child: Text(title)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    height: SizeConfig.safeBlockVertical *25,
                    child: FlareActor(
                      "assets/flare/order_arrive.flr",
                      animation: "default",
                    ),
                  ),
                  Text(body),
                ],
              ),
              actions: [
                MaterialButton(
                  child: Text(
                    "Okay",
                    style: TextStyle(color: Colors.pinkAccent),
                  ),
                  onPressed: () async{
                    Dio dio = Dio();
                    print("+++++++++++++++++++++++++++++");
                    print(Common.droneServer);
                    dio.get(Common.droneServer);
//                    print(response.data);
//                    Fluttertoast.showToast(
//                        msg: response.data,
//                        toastLength: Toast.LENGTH_SHORT,
//                        gravity: ToastGravity.BOTTOM,
//                        timeInSecForIosWeb: 1,
//                        textColor: Colors.black,
//                        fontSize: 12.0
//                    );
                    final firestore = Firestore.instance;
                    await firestore.collection('Drones').document(droneId).updateData({
                      "isReleased":true,
                      "currentOrder":""
                    });
                    await firestore.collection('order').document(id).updateData({
                      "orderStatus":enumToString(OrderStatus.completed.toString())
                    });
                    Navigator.pop(context);
                  },
                ),
              ],
            ));
  }
}
