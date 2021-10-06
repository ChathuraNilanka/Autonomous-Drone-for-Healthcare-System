import 'package:emedic/models/user.dart';
import 'package:emedic/resources/repository.dart';
import 'package:emedic/ui/facial_recognizer/recognize_face.dart';
import 'package:emedic/ui/facial_recognizer/scan_face.dart';
import 'package:emedic/ui/order/order_list.dart';
import 'package:emedic/ui/others/chat.dart';
import 'package:emedic/ui/others/doctors.dart';
import 'package:emedic/ui/others/faq.dart';
import 'package:emedic/ui/others/root.dart';
import 'package:emedic/ui/others/settings.dart';
import 'package:emedic/ui/prescription/camera_upload.dart';
import 'package:emedic/utils/common.dart';
import 'package:emedic/utils/enumeration.dart';
import 'package:emedic/utils/size_config.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class AppScaffold extends StatelessWidget {
  final Widget child;
  final DrawerPages page;
  final FloatingActionButton floatingActionButton;

  const AppScaffold({
    Key key,
    @required this.page,
    @required this.child,
    this.floatingActionButton,
  }) : super(key: key);

  static final _drawerList = [
    DrawerList(
        title: PageTitles.home,
        iconData: FontAwesomeIcons.home,
        pushTo: Root(),
        page: DrawerPages.Home),
    DrawerList(
        title: PageTitles.orders,
        iconData: FontAwesomeIcons.list,
        pushTo: OrderList(),
        page: DrawerPages.OrderList),
//    DrawerList(
//        title: PageTitles.uploadPrescription,
//        iconData: FontAwesomeIcons.camera,
//        pushTo: CameraUpload(),
//        page: DrawerPages.cameraUpload),
    DrawerList(
        title: PageTitles.faq,
        iconData: FontAwesomeIcons.question,
        pushTo: FAQ(),
        page: DrawerPages.faq),
    DrawerList(
        title: PageTitles.chat,
        iconData: Icons.message,
        pushTo: Chat(),
        page: DrawerPages.chat),
    DrawerList(
        title: PageTitles.doctor,
        iconData: FontAwesomeIcons.userMd,
        pushTo: Doctors(),
        page: DrawerPages.doctors),
    DrawerList(
        title: PageTitles.settings,
        iconData: FontAwesomeIcons.cogs,
        pushTo: Settings(),
        page: DrawerPages.settings),
  ];

  @override
  Widget build(BuildContext context) {
    String title;
    switch (page) {
      case DrawerPages.Home:
        title = PageTitles.home;
        break;
      case DrawerPages.MedicalHistory:
        title = PageTitles.medicalHistory;
        break;
      case DrawerPages.OrderList:
        title = PageTitles.orders;
        break;
      case DrawerPages.cameraUpload:
        title = PageTitles.uploadPrescription;
        break;
      case DrawerPages.faq:
        title = PageTitles.faq;
        break;
      case DrawerPages.settings:
        title = PageTitles.settings;
        break;
      case DrawerPages.chat:
        title = PageTitles.chat;
        break;
      case DrawerPages.doctors:
        title = PageTitles.doctor;
        break;
    }

    Future<bool> _onWillPop() async {
      return (await showDialog(
            context: context,
            builder: (context) => new AlertDialog(
              title: new Text('Are you sure?'),
              content: new Text('Do you want to exit an App'),
              actions: <Widget>[
                new FlatButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: new Text('No'),
                ),
                new FlatButton(
                  onPressed: () {
                    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                  },
                  child: new Text('Yes'),
                ),
              ],
            ),
          )) ??
          false;
    }

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        floatingActionButton: floatingActionButton,
        appBar: AppBar(
          title: Text(title),
        ),
        body: Container(
//          decoration: BoxDecoration(
//            image: DecorationImage(
//              fit: BoxFit.cover,
//              image: AssetImage("assets/images/background.jpg")
//            )
//          ),
            child: child),
        drawer: Drawer(
          child: Column(
            children: <Widget>[
//            Container(
//              height: 150,
//              alignment: Alignment.center,
//              child: Stack(
//                children: <Widget>[
//                  Text(Common.displayName,style: Theme.of(context).textTheme.headline5,),
//                  Positioned(
//                    left: 0,
//                    bottom: 0,
//                    child: CircleAvatar(
//                      backgroundColor: Colors.transparent,
//                      child: Image.asset("assets/images/logo.png")
//                    ),
//                  )
//                ],
//              ),
//            ),
//            Divider(),
              Expanded(
                child: ListView.builder(
                  itemCount: _drawerList.length,
                  itemBuilder: (context, count) {
                    return ListTile(
                      title: Text(_drawerList[count].title),
                      leading: Icon(_drawerList[count].iconData),
                      onTap: () {
                        if (page != _drawerList[count].page) {
                          Navigator.pop(context);
                          pushPage(context, _drawerList[count].pushTo);
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        bottomSheet: FutureBuilder<FirebaseUser>(
            future: FirebaseAuth.instance.currentUser(),
          builder: (context, snapshot) {
              if(!snapshot.hasData)
                return SizedBox.shrink();
              final id = snapshot.data.uid;
            return FutureBuilder(
              future: Repository().getUser(id), builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
              if(!snapshot.hasData)
                return SizedBox.shrink();
                final enabled = snapshot?.data?.authenticationEnabled?? false;

                if(enabled)
                  return SizedBox.shrink();
                return Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(child: Text("Please activate your account and enjoy the full functionality of the eMedic",
                              style: GoogleFonts.arvo(
                                textStyle:
                                                              TextStyle(
                              fontSize: SizeConfig.blockSizeHorizontal * 4),
                              ),

                            )),
                            RawMaterialButton(
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(
                                builder:(context)=> ScanFace()
                              ));
                            },
                              fillColor: Theme.of(context).accentColor,
                              child:Text("Activate",style: Theme.of(context).textTheme.headline6.copyWith(fontSize: SizeConfig.blockSizeHorizontal * 3,color: Colors.white),),
                              splashColor: Colors.transparent,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                );
            },
            );
          }
        ),
      ),
    );
  }
}

class DrawerList {
  String title;
  IconData iconData;
  DrawerPages page;
  Widget pushTo;

  DrawerList({
    @required this.title,
    @required this.iconData,
    @required this.pushTo,
    @required this.page,
  });
}
