import 'package:emedic/resources/repository.dart';
import 'package:emedic/ui/others/medical_history_widget.dart';
import 'package:emedic/ui/others/notification_messages.dart';
import 'package:emedic/utils/common.dart';
import 'package:emedic/utils/enumeration.dart';
import 'package:emedic/utils/widgets/app_scaffold.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Root extends StatefulWidget {
  @override
  _RootState createState() => _RootState();
}

class _RootState extends State<Root> {
//  bool _isFirst = true;
//  bool _sos = false;
//  String _sosTitle = "";
//  String _sosLink = "";
  @override
  void initState() {
    super.initState();
    _init();
    _initFirebase();
  }

  void _initFirebase(){
    FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
    NotificationMessage notificationMessage = NotificationMessage(context);
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        final data = message["data"];
        final title = data["title"];
        final body = data["body"];
        final screen = data["screen"];
        final id = data["id"];
        switch(screen){
          case "request_create":
            final doctorId = data["doctorId"];
            notificationMessage.showRequestNotification(title, body, id,doctorId);
            break;
          case "request_delete":
            notificationMessage.showNormalNotification(title, body);
            break;
          case "request_update":
            break;
          case "package_release":
            notificationMessage.showArrivalNotification(title, body,id,data["droneId"]);
            break;
          default:
            notificationMessage.showNormalNotification(title, body);
            break;
        }
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        final data = message["data"];
        final title = data["title"];
        final body = data["body"];
        final screen = data["screen"];
        final id = data["id"];
        switch(screen) {
          case "request_create":
            final doctorId = data["doctorId"];
            notificationMessage.showRequestNotification(
                title, body, id, doctorId);
            break;
          case "package_release":
            notificationMessage.showArrivalNotification(title, body,id,data["droneId"]);
            break;
          default:
            notificationMessage.showNormalNotification(title, body);
            break;
        }
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        final data = message["data"];
        final title = data["title"];
        final body = data["body"];
        final screen = data["screen"];
        final id = data["id"];
        switch(screen) {
          case "request_create":
            final doctorId = data["doctorId"];
            notificationMessage.showRequestNotification(
                title, body, id, doctorId);
            break;
          case "package_release":
            notificationMessage.showArrivalNotification(title, body,id,data["droneId"]);
            break;
          default:
            notificationMessage.showNormalNotification(title, body);
            break;
        }
      },
    );
  }

  Future<void> _init() async {
    final Repository _repo = Repository();
    FirebaseMessaging firebaseMessaging = FirebaseMessaging();
    String token = await firebaseMessaging.getToken();
    String saved = await _repo.getDeviceToken();
    if (saved != token) _repo.saveDeviceToken(token);
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      page: DrawerPages.Home,
      child: Container(
        child: Column(
          children: <Widget>[
            _sosAlert(context),
            Expanded(child: MedicalHistoryWidget()),
          ],
        ),
      ),
    );
  }

  Container _sosAlert(BuildContext context) {
    if(SoS.sosTitle == null || SoS.sosTitle.isEmpty)
      return Container();
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      width: double.maxFinite,
      height: MediaQuery.of(context).size.width * 0.15,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.redAccent),
      ),
      child: InkWell(
        onTap: ()async{
          if (await canLaunch(SoS.sosLink)) {
          await launch(SoS.sosLink);
          } else {
          throw 'Could not launch';
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              SoS.sosTitle,
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(fontSize: MediaQuery.of(context).size.width * 0.043),
            ),
            Text(
              SoS.sosSubtitle,
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
      ),
    );
  }
}
