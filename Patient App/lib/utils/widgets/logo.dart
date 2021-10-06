import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final double size;

  const Logo({Key key,this.size=50}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(
          image: AssetImage("assets/images/logo.png")
        )
      ),
    );
  }
}

class GlowLogo extends StatelessWidget {
  final double size;
  final double radius;
  final double endRadius;

  const GlowLogo({Key key, this.size=50, this.radius=40, this.endRadius=70}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      child: AvatarGlow(
        endRadius: endRadius,   //required
        child: Material(   //required
          elevation: 8.0,
          shape: CircleBorder(),
          child: CircleAvatar(
              backgroundColor:Colors.grey[100] ,
              child: Logo(size: size,),
              radius: radius,
          ),
        ),
        curve: Curves.fastOutSlowIn,
      ),
    );
  }
}
