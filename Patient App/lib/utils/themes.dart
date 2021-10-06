import 'package:flutter/material.dart';

final backgroundColor = Colors.blueGrey.withOpacity(0.15);
class MyThemes {
  static final ThemeData theme1 = ThemeData(
    primaryColor: Color(0xFF739bF3),
    accentColor: Color(0xFF449BC4),
    buttonTheme: ButtonThemeData(
      padding: EdgeInsets.all(18),
      buttonColor: Color(0xFF739bF3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
      textTheme: ButtonTextTheme.primary,
    ),
    dialogTheme: DialogTheme(
      elevation: 10,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
      ),
    ),
  );

  static final theme2 = ThemeData(
    primaryColor: Color(0xFF00E1D3),
    accentColor: Color(0xFF00B4D5),
//    primaryColor: Color(0xff00adb5),
//    accentColor: Colors.cyanAccent,
    buttonTheme: ButtonThemeData(
      padding: EdgeInsets.all(18),
      buttonColor: Color(0xFF00E1D3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
      textTheme: ButtonTextTheme.primary,
    ),
    dialogTheme: DialogTheme(
    elevation: 10,
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15)
    ),
  ),
  );

  static final theme3 = ThemeData(
    primaryColor: Color(0xFF65D5A3),
    accentColor: Color(0xFF3B9CA7),
    buttonTheme: ButtonThemeData(
      padding: EdgeInsets.all(18),
      buttonColor: Color(0xFF65D5A3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
      textTheme: ButtonTextTheme.primary,
    ),
    dialogTheme: DialogTheme(
      elevation: 10,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
      ),
    ),
  );

  static final theme4 = ThemeData(
    primaryColor: Color(0xFFFC747E),
    accentColor: Color(0xFFF666A3),
    dialogTheme: DialogTheme(
      elevation: 10,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
      ),
    ),
    buttonTheme: ButtonThemeData(
      padding: EdgeInsets.all(18),
      buttonColor: Color(0xFFFC747E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
      textTheme: ButtonTextTheme.primary,
    ),
  );

  static final theme5 = ThemeData(
    primaryColor: Color(0xFFFEC6E3),
    accentColor: Color(0xFFFF9B9D),
    buttonTheme: ButtonThemeData(
      padding: EdgeInsets.all(18),
      buttonColor: Color(0xFFFEC6E3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
      textTheme: ButtonTextTheme.primary,
    ),
    dialogTheme: DialogTheme(
      elevation: 10,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
      ),
    ),
  );

  static final theme6 = ThemeData(
    primaryColor: Color(0xFF858AE5),
    accentColor: Color(0xFF786FC0),
    buttonTheme: ButtonThemeData(
      padding: EdgeInsets.all(18),
      buttonColor: Color(0xFF858AE5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
      textTheme: ButtonTextTheme.primary,
    ),
    dialogTheme: DialogTheme(
      elevation: 10,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15)
      ),
    ),
  );

  final themes = [theme1,theme2,theme3,theme4,theme5,theme6];

  MyThemeTypes stringToThemeType(String theme){
    switch (theme){
      case "theme1":
        return MyThemeTypes.theme1;
      case "theme2":
        return MyThemeTypes.theme2;
      case "theme3":
        return MyThemeTypes.theme3;
      case "theme4":
        return MyThemeTypes.theme4;
      case "theme5":
        return MyThemeTypes.theme5;
      case "theme6":
        return MyThemeTypes.theme6;
    }
    return MyThemeTypes.theme1;
  }

  getThemes(MyThemeTypes themeTypes){
    switch(themeTypes){
      case MyThemeTypes.theme1:
        return theme1;
        break;
      case MyThemeTypes.theme2:
        return theme2;
        break;
      case MyThemeTypes.theme3:
        return theme3;
        break;
      case MyThemeTypes.theme4:
        return theme4;
        break;
      case MyThemeTypes.theme5:
        return theme5;
        break;
      case MyThemeTypes.theme6:
        return theme6;
        break;
    }
  }

}
enum MyThemeTypes{theme1,theme2,theme3,theme4,theme5,theme6}