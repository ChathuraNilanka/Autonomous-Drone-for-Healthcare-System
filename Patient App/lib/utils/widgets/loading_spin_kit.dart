import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class LoadingSpinKit extends StatelessWidget {
  final double size;

  const LoadingSpinKit({Key key, this.size=25}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(child: SpinKitDualRing(
      color: Colors.white,
      size: size,
    ),);
  }
}
