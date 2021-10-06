import 'package:emedic/models/user.dart';
import 'package:emedic/resources/repository.dart';
import 'package:emedic/resources/user_provider.dart';
import 'package:emedic/ui/others/root.dart';
import 'package:emedic/utils/common.dart';
import 'package:emedic/utils/widgets/background.dart';
import 'package:emedic/utils/widgets/logo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class OTPVerification extends StatefulWidget {
  final String verificationId;

  const OTPVerification({Key key, this.verificationId}) : super(key: key);
  @override
  _OTPVerificationState createState() => _OTPVerificationState();
}

class _OTPVerificationState extends State<OTPVerification> {
  TextEditingController _textEditingController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    return Scaffold(
      body: Background(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Container(
                      child: Hero(
                          tag: HeroText.heroLogo,
                          child: GlowLogo(
                            size: 150,
                          )),
                    ),
                    Expanded(
                      child: Hero(
                          tag: HeroText.heroAppName,
                          child: Text(
                            APP_NAME,
                            style: theme.textTheme.headline4.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w900),
                          )),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                height: 100,
                child: FlareActor(
                  "assets/flare/otp_success.flr",
                  alignment: Alignment.center,
                  fit: BoxFit.contain,
                  animation: "animate",
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                child: Text(
                  OTPVerificationPageText.title,
                  style: theme.textTheme.headline5.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                child: Text(
                  OTPVerificationPageText.description,
                  style: theme.textTheme.bodyText1
                      .copyWith(color: Colors.blueGrey),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        height: 25,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: TextField(
                                controller: _textEditingController,
                                decoration: InputDecoration(
                                    hintText: OTPVerificationPageText.hint,
                                    border: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                          const Radius.circular(10.0),
                                        ),
                                        borderSide: BorderSide(
                                            color: Colors.grey[400])),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: const BorderRadius.all(
                                          const Radius.circular(10.0),
                                        ),
                                        borderSide:
                                            BorderSide(color: Colors.grey)),
                                    filled: true,
                                    fillColor: Colors.white,
                                    counter: Container()),
                                style: TextStyle(color: theme.primaryColor),
                                maxLength: 10,
                                keyboardType: TextInputType.phone,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        alignment: Alignment.center,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(45)),
                          elevation: 10,
                          child: Container(
                            width: width * 0.85,
                            height: 50,
                            child: GestureDetector(
                              onTap: () async {
                                String otp = _textEditingController.text;
//                                FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
                                AuthCredential credential =
                                    PhoneAuthProvider.getCredential(
                                  verificationId: widget.verificationId,
                                  smsCode: otp,
                                );

                                AuthResult result = await FirebaseAuth.instance
                                    .signInWithCredential(credential);
                                String uid = result.user.uid;
                                User _user = User();
                                FirebaseUser firebaseUser = result.user;
                                UserProvider provider = UserProvider();
                                _user.id = uid;
                                bool res = await provider.isUser(uid);
                                if (!res) {
                                  await firebaseUser.updateEmail(_user.email);
                                  await Repository().registerUser(uid);
                                } else {
                                  await Repository().getUser(uid);
                                }
                                pushReplaced(context, Root());
                              },
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  OTPVerificationPageText.verifyButton,
                                  style: theme.textTheme.headline6
                                      .copyWith(color: Colors.white),
                                ),
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [
                                      theme.primaryColor,
                                      theme.accentColor,
                                      theme.primaryColor
                                    ]),
                                    borderRadius: BorderRadius.circular(45)),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
