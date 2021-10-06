import 'package:emedic/utils/common.dart';
import 'package:emedic/utils/widgets/background.dart';
import 'package:emedic/utils/widgets/common_account_information.dart';
import 'package:emedic/utils/widgets/logo.dart';
import 'package:flutter/material.dart';

class SignUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
//    final width = MediaQuery.of(context).size.width;
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
              Container(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  SignUpPageText.title,
                  style:
                      theme.textTheme.headline5.copyWith(color: Colors.white),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              CommonAccountInformation(
                signup: true,
              ),
              SizedBox(
                height: 50,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
