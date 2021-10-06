import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final Widget child;

  const Background({Key key,this.child}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: child,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [
                theme.primaryColor,
                theme.accentColor
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight
          )
      ),
    );
  }
}
