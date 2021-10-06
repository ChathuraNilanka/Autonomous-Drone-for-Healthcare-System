import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoInternet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            Text("No Internet Access",style: Theme.of(context).textTheme.headline4,),
            Expanded(
              child: FlareActor(
                "assets/flare/no_wifi.flr",animation: "Untitled",
              ),
            ),
            SizedBox(height: 10,),
            Container(
              width: double.infinity,
              child: RaisedButton(
                onPressed: (){

                },
                child: Text("Open Settings"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
