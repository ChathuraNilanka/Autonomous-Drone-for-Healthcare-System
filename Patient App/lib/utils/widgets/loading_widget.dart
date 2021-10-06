import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

///This is splash screen
///
class LoadingWidget extends StatelessWidget {
  final double size;

  const LoadingWidget({Key key, this.size=40}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SpinKitCircle(
        size: size,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}

class PleaseWait extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Container(
      padding: EdgeInsets.all(25),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Spacer(),
              SpinKitRing(color: primaryColor,size: 25,lineWidth: 5,),
              SizedBox(width: 15,),
              Text("Please Wait",style: Theme.of(context).textTheme.headline6,),
              Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}


