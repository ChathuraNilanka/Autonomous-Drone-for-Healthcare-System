
import 'package:emedic/utils/enumeration.dart';
import 'package:emedic/utils/themes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MySharedPreferences{
  final String _theme = "theme";

  Future<String> getTheme() async {
    final SharedPreferences _sharedPreference =await SharedPreferences.getInstance();
    String theme=_sharedPreference.getString(_theme);
    if(theme==null|| theme.isEmpty)
      theme = "theme4";
    return theme;
  }

  Future<void> saveTheme(MyThemeTypes themeTypes)async{
    final SharedPreferences _sharedPreference =await SharedPreferences.getInstance();
    await _sharedPreference.setString(_theme, enumToString(themeTypes.toString()));
  }
}