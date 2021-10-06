import 'package:emedic/models/user.dart';
import 'package:emedic/my_inherited_widget.dart';
import 'package:emedic/resources/repository.dart';
import 'package:emedic/ui/auth/auth_main.dart';
import 'package:emedic/utils/common.dart';
import 'package:emedic/utils/enumeration.dart';
import 'package:emedic/utils/themes.dart';
import 'package:emedic/utils/widgets/app_scaffold.dart';
import 'package:emedic/utils/widgets/logo.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:package_info/package_info.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  MyThemes _myThemes = MyThemes();
  String _version;
  String _buildNumber;
  FirebaseUser _firebaseUser;
  Repository _repository = Repository();

  @override
  void initState() {
    super.initState();
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
       setState(() {
         _version = packageInfo.version;
         _buildNumber = packageInfo.buildNumber;
       });
    });
    FirebaseAuth.instance.currentUser().then((value) {
      setState(() {
        _firebaseUser = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return AppScaffold(
        page: DrawerPages.settings,
        child: Container(
          color: backgroundColor,
          child: ListView(
            children: <Widget>[
              _buildUserInfo(),
              SizedBox(height: 5,),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(SettingsPageText.settings,style: textTheme.headline6,),
                      SizedBox(height: 15,),
                      Container(
                          height: 80,
                          child: _themes()),
                      SizedBox(height: 15,),
                      Container(
                        width: double.infinity,
                        child: RaisedButton(
                          onPressed: ()async {
                            final auth = FirebaseAuth.instance;
                            await auth.signOut();
                            Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                AuthMain()), (Route<dynamic> route) => false);
                          },
                          child: Text(SettingsPageText.signout),
                        ),
                      ),
                      SizedBox(height: 20,)
                    ],
                  ),
                ),
              ),
              SizedBox(height: 50,),
              SizedBox(height: 35,),
              Logo(size: 70,),
              Text(APP_NAME,style: textTheme.headline4,textAlign: TextAlign.center,),
              SizedBox(height: 10,),
              SizedBox(height: 15,),
              Text("Verson $_version $_buildNumber",style: textTheme.headline6.copyWith(color:Colors.grey),textAlign: TextAlign.center,),
            ],
          ),
        ));
  }

  Widget _themes(){
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: _myThemes.themes.length,
      itemBuilder: (context,index){
        final primary = _myThemes.themes[index].primaryColor;
        final secondary = _myThemes.themes[index].accentColor;
        return InkWell(
          borderRadius: BorderRadius.circular(65),
          onTap: (){
            MyThemeTypes myThemeTypes = MyThemeTypes.theme1;
            switch(index){
              case 0:
                myThemeTypes = MyThemeTypes.theme1;
                break;
              case 1:
                myThemeTypes = MyThemeTypes.theme2;
                break;
              case 2:
                myThemeTypes = MyThemeTypes.theme3;
                break;
              case 3:
                myThemeTypes = MyThemeTypes.theme4;
                break;
              case 4:
                myThemeTypes = MyThemeTypes.theme5;
                break;
              case 5:
                myThemeTypes = MyThemeTypes.theme6;
                break;
            }
            MyInheritedWidget.of(context).onMyThemeChange(myThemeTypes);
          },
          child: Container(
            margin: const EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                    color: Colors.white,
                    blurRadius: 6.0,
                    spreadRadius: 2),
              ],
            ),
            padding: const EdgeInsets.all(5.0),
            child: Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                      colors: [primary,secondary]
                  )
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildUserInfo(){
    if(_firebaseUser==null)
      return Container();
    final textTheme = Theme.of(context).textTheme;
    final titleStyle = textTheme.headline6.copyWith(fontWeight: FontWeight.normal);
    final subTitle = textTheme.headline6.copyWith(fontWeight: FontWeight.normal,color: Colors.grey,fontSize: MediaQuery.of(context).size.width * 0.037);
    return FutureBuilder(
      future: _repository.getUser(_firebaseUser.uid),
      builder: (context,snapshot){
        if(!snapshot.hasData)
          return Container();
        else {
          final User user = snapshot.data;
          return Column(
            children: <Widget>[
              SizedBox(height: 5,),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 12,),
                      Text(SettingsPageText.info,style: textTheme.headline6,),
                      SizedBox(height: 25,),
                      _infoItem(
                        title: Text(user.fullName,style: titleStyle,),
                        subtitle: Text(SettingsPageText.fullName,style: subTitle,),
                      ),
                      Divider(),
                      _infoItem(
                        title: Text(user.displayName,style: titleStyle,),
                        subtitle: Text(SettingsPageText.displayName,style: subTitle,),
                      ),
                      Divider(),
                      _infoItem(
                        title: Text(user.mobileNumber,style: titleStyle,),
                        subtitle: Text(SettingsPageText.mobileNumber,style: subTitle,),
                      ),
                      Divider(),
                      _infoItem(
                        title: Text(user.email,style: titleStyle,),
                        subtitle: Text(SettingsPageText.email,style: subTitle,),
                      ),
                      SizedBox(height: 25,)
                    ],
                  ),
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _infoItem({Widget title, Widget subtitle}){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        title,subtitle
      ],
    );
  }

}

