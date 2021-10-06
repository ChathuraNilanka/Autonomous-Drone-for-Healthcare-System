import 'package:emedic/ui/auth/login.dart';
import 'package:emedic/ui/auth/signup.dart';
import 'package:emedic/utils/common.dart';
import 'package:emedic/utils/widgets/background.dart';
import 'package:emedic/utils/widgets/logo.dart';
import 'package:flutter/material.dart';

class AuthMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final theme = Theme.of(context);
    return Scaffold(
      body: Background(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Spacer(
              flex: 3,
            ),
            Container(
              child: Hero(
                  tag: HeroText.heroLogo,
                  child: GlowLogo(
                    size: 150,
                  )),
            ),
            SizedBox(
              height: 25,
            ),
            Hero(
                tag: HeroText.heroAppName,
                child: Text(
                  APP_NAME,
                  style: theme.textTheme.headline4.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w900),
                )),
            Text(
              AuthPageText.greeting,
              style: TextStyle(
                  fontSize: width * 0.05,
                  color: Colors.white70,
                  fontWeight: FontWeight.normal),
            ),
            Spacer(
              flex: 3,
            ),
            Container(
              alignment: Alignment.center,
              child: Container(
                width: width * 0.85,
                child: RaisedButton(
                  onPressed: () => pushPage(context, SignUp()),
                  elevation: 20,
                  color: Colors.white,
                  child: Text(
                    AuthPageText.signUpButton,
                    style: theme.textTheme.headline6
                        .copyWith(color: theme.primaryColor),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            GestureDetector(
              onTap: () => pushPage(context, Login()),
              child: Container(
                padding: const EdgeInsets.all(14.0),
                child: Text(
                  AuthPageText.loginButton,
                  style:
                      theme.textTheme.headline6.copyWith(color: Colors.white),
                ),
              ),
            ),
            Spacer(
              flex: 3,
            ),
          ],
        ),
      ),
    );
  }
}

class DefaultButton extends StatelessWidget {
  final TextStyle style;
  final String text;
  final onPressed;
  final Color color;
  final double elevation;

  const DefaultButton({
    Key key,
    this.style,
    @required this.text,
    @required this.onPressed,
    this.color,
    this.elevation = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: onPressed,
      elevation: elevation,
      color: color,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Center(
            child: Text(
          text,
          style: style,
        )),
      ),
    );
  }
}
