import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:emedic/models/user.dart';
import 'package:emedic/resources/repository.dart';
import 'package:emedic/resources/user_provider.dart';
import 'package:emedic/ui/auth/otp_verification.dart';
import 'package:emedic/ui/auth/signup.dart';
import 'package:emedic/ui/others/root.dart';
import 'package:emedic/utils/common.dart';
import 'package:emedic/utils/widgets/background.dart';
import 'package:emedic/utils/widgets/loading_spin_kit.dart';
import 'package:emedic/utils/widgets/logo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Country _selectedCountry = Country(phoneCode: "94");
  TextEditingController _editingController = TextEditingController();
  bool _loading = false;

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
                  "assets/flare/otp_verification.flr",
                  alignment: Alignment.center,
                  fit: BoxFit.contain,
                  animation: "otp",
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                child: Text(
                  LoginPageText.title,
                  style: theme.textTheme.headline5.copyWith(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                child: Text(
                  LoginPageText.description,
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
                            Container(
                              child: CountryPickerDropdown(
                                initialValue: 'lk',
                                itemBuilder: _buildDropdownItem,
                                onValuePicked: (Country country) {
                                  setState(() {
                                    _selectedCountry = country;
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                controller: _editingController,
                                decoration: InputDecoration(
                                    hintText: LoginPageText.phoneNumberHint,
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
                              onTap: () => _login(),
                              child: Container(
                                alignment: Alignment.center,
                                child: Row(
                                  children: <Widget>[
                                    Spacer(),
                                    Expanded(
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          LoginPageText.loginButton,
                                          style: theme.textTheme.headline6
                                              .copyWith(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    _loading
                                        ? Expanded(
                                            child: LoadingSpinKit(
                                              size: 20,
                                            ),
                                          )
                                        : Spacer()
                                  ],
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
              SizedBox(
                height: 50,
              ),
              Container(
                padding: const EdgeInsets.all(8),
                child: Text(
                  "By signing in you are agreed to our Privacy Policy and Terms of Service",
                  style: TextStyle(color: Colors.white54),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    setState(() {
      _loading = true;
    });
    FirebaseAuth auth = FirebaseAuth.instance;

    String _temp = _editingController.text;

    if(_temp[0] == "0"){
      _temp = _temp.substring(1);
    }

    String number = "+${_selectedCountry.phoneCode}$_temp";

    bool alreadyUser = await Repository().isAlreadyRegisteredMobileNumber(number);

    if(User().gender == null && !alreadyUser){
      pushReplaced(context, SignUp());
    }else{
      User _user = User();
      _user.mobileNumber = number;
          await auth.verifyPhoneNumber(
        phoneNumber: number,
        timeout: Duration(seconds: 10),
        verificationCompleted: (AuthCredential credential)async {

          AuthResult result =await FirebaseAuth.instance.signInWithCredential(credential);
          String uid = result.user.uid;

          FirebaseUser firebaseUser = result.user;
          UserProvider provider = UserProvider();
          _user.id = uid;
          bool res = await provider.isUser(uid);
          if(!res){
            await firebaseUser.updateEmail(_user.email);
            await Repository().registerUser(uid);
          }else{
            await Repository().getUser(uid);
          }
          pushReplaced(context, Root());
        },
        verificationFailed: (_) {
          print(_.message);
          print("something went wrong");
        },
        codeSent: (verificationId, [code]) {
          pushPage(context, OTPVerification(verificationId:verificationId));
        },
        codeAutoRetrievalTimeout: null);
    }

    setState(() {
      _loading = false;
    });
  }

  Widget _buildDropdownItem(Country country) => Container(
        child: Row(
          children: <Widget>[
            CountryPickerUtils.getDefaultFlagImage(country),
            SizedBox(
              width: 8.0,
            ),
            Text("+${country.phoneCode}(${country.isoCode})"),
          ],
        ),
      );
}
