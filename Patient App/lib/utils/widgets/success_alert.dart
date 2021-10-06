import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SuccessAlert extends StatelessWidget {
  final String title;
  final String content;
  final MaterialButton button;

  const SuccessAlert({Key key, this.title, this.content, this.button}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        textAlign: TextAlign.center,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 100,
            child: FlareActor(
              "assets/flare/success.flr",
              fit: BoxFit.contain,
              animation: "Untitled",
            ),
          ),
          Text(content),
        ],
      ),
      actions: <Widget>[
        button
      ],
    );
  }
}
