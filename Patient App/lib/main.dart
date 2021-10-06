import 'package:emedic/resources/repository.dart';
import 'package:emedic/ui/auth/auth_main.dart';
import 'package:emedic/ui/others/root.dart';
import 'package:emedic/utils/common.dart';
import 'package:emedic/utils/size_config.dart';
import 'package:emedic/utils/themes.dart';
import 'package:emedic/utils/widgets/loading_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_map_location_picker/generated/i18n.dart'
    as location_picker;

import 'models/user.dart';
import 'my_inherited_widget.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(MyInheritedWidget(
      child: MyApp(),
    ));
  });
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: APP_NAME,
      theme: MyThemes().getThemes(MyInheritedWidget.of(context).myThemeTypes),
      home: SplashScreen(),
      localizationsDelegates: const [
        location_picker.S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const <Locale>[
        Locale('en', ''),
      ],
    );
  }
}

class SplashScreen extends StatelessWidget {
  Future<void> _getRemoteConfig() async {
    final RemoteConfig remoteConfig = await RemoteConfig.instance;
    await remoteConfig.fetch(expiration: const Duration(seconds: 0));
    await remoteConfig.activateFetched();
    print(remoteConfig.getAll().length);
    SoS.sosTitle = remoteConfig.getString("sos_title");
    SoS.sosSubtitle = remoteConfig.getString("sos_subtitle");
    SoS.sosLink = remoteConfig.getString("sos_link");
    Common.facialServer = remoteConfig.getString("facial_server");
    Common.droneServer = remoteConfig.getString("drone_server");

  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    _getRemoteConfig();
    FirebaseAuth.instance.currentUser().then((FirebaseUser user) {
      if (user != null) {
//        if (!user.isEmailVerified) {
//          user.sendEmailVerification();
//        }
        Common.profilePicture = user.photoUrl;
        Repository().getUser(user.uid).then((User user) {
//          User u = User();
          Common.displayName = user.displayName;
//          u = user;
          pushReplaced(context, Root());
        });
      } else {
        pushReplaced(context, AuthMain());
      }
    });
    return Scaffold(
        body: Container(
      child: LoadingWidget(),
    ));
  }
}
