import 'package:emedic/resources/my_shared_preferencees.dart';
import 'package:emedic/utils/themes.dart';
import 'package:flutter/material.dart';

class MyInheritedWidget extends StatefulWidget {
  final Widget child;

  const MyInheritedWidget({Key key, @required this.child}) : super(key: key);

  static MyInheritedData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType();
  @override
  _MyInheritedWidgetState createState() => _MyInheritedWidgetState();
}

class _MyInheritedWidgetState extends State<MyInheritedWidget> {
  MyThemeTypes themeTypes;

  @override
  void initState() {
    super.initState();
    themeTypes= MyThemeTypes.theme4;
    _getTheme();
  }
  void _getTheme()async{
    String theme=await MySharedPreferences().getTheme();
    updateTheme(MyThemes().stringToThemeType(theme));
  }

  void updateTheme(MyThemeTypes theme){
    setState(() {
      themeTypes = theme;
    });
    MySharedPreferences().saveTheme(theme);
  }

  @override
  Widget build(BuildContext context) {
    return MyInheritedData(
      child: widget.child,
      myThemeTypes: themeTypes,
      onMyThemeChange: updateTheme,
    );
  }
}



class MyInheritedData extends InheritedWidget {
  final MyThemeTypes myThemeTypes;
  final ValueChanged<MyThemeTypes> onMyThemeChange;
  MyInheritedData( {Key key,this.onMyThemeChange,this.myThemeTypes,Widget child}):super(key:key,child:child);
  @override
  bool updateShouldNotify(MyInheritedData oldWidget) {
    return oldWidget.myThemeTypes != myThemeTypes;
  }

}
