import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emedic/utils/enumeration.dart';
import 'package:emedic/utils/size_config.dart';
import 'package:emedic/utils/widgets/app_scaffold.dart';
import 'package:emedic/utils/widgets/loading_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Doctors extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firestore = Firestore.instance;
    return AppScaffold(
      page: DrawerPages.doctors,
      child: Container(
        child: FutureBuilder(
          future: FirebaseAuth.instance.currentUser(),
          builder: (BuildContext context, AsyncSnapshot<FirebaseUser> snapshot) { 
            if(!snapshot.hasData)
            return LoadingWidget();
            return StreamBuilder(
              stream: firestore.collection("patients").document(snapshot.data.uid).collection("doctors").snapshots(), builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if(!snapshot.hasData)
                return LoadingWidget();
              final data = snapshot.data.documents;
              if(data == null)
                return Container();
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context,index)=> _buildDoctor(data[index],context),
              );
            },

            );
          },
          
        ),
      ),
    );
  }

  Widget _buildDoctor(DocumentSnapshot data,BuildContext context) {
    final firestore = Firestore.instance;
    final theme = Theme.of(context).textTheme;
    final nameStyle =theme.headline6.copyWith(fontSize: SizeConfig.blockSizeHorizontal*4);
    final specStyle =theme.headline4.copyWith(fontSize: SizeConfig.blockSizeHorizontal*3.5,fontWeight: FontWeight.bold);
    final emailStyle =theme.headline5.copyWith(fontSize: SizeConfig.blockSizeHorizontal*3.2);
    final bioStyle =theme.bodyText2.copyWith(fontSize: SizeConfig.blockSizeHorizontal*3);
    return FutureBuilder(
      future: firestore.collection("doctor").document(data.data["docID"]).get(), builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if(!snapshot.hasData)
          return Container();
        final data = snapshot.data.data;
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: SizeConfig.safeBlockHorizontal *4, vertical: SizeConfig.safeBlockVertical *2),
          child: InkWell(
            onTap: ()=>_buildTimeTable(snapshot.data.reference.collection("timeTable"),context),
            child: Row(
              children: [
                Container(
                  width: SizeConfig.blockSizeHorizontal*20,
                  height: SizeConfig.blockSizeHorizontal*20,
                  child: CachedNetworkImage(imageUrl: data["proPic"]??" ",
                  imageBuilder: (context,image)=>Material(
                      elevation: 10,
      borderRadius: BorderRadius.circular(SizeConfig.screenWidth),
                      child: CircleAvatar(backgroundImage: image)),
                    placeholder: (context,_)=>Container(child: LoadingWidget(size: 10,),),
                    errorWidget: (context,_,__)=>Center(child: Icon(Icons.error),),
                  ),
                ),
                SizedBox(
                  width: SizeConfig.safeBlockHorizontal *2,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(data["name"]??"",style: nameStyle,),
                      SizedBox(
                        height: SizeConfig.safeBlockHorizontal *2,
                      ),
                      Text(data["specialty"]??"",style: specStyle,),
                      SizedBox(
                        height: SizeConfig.safeBlockHorizontal *.5,
                      ),
                      Text(data["email"]??"",style: emailStyle,),
                      SizedBox(
                        height: SizeConfig.safeBlockHorizontal *.5,
                      ),
                      Text(data["bio"]??"",style: bioStyle,),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
    },
    );
  }

  _buildTimeTable(CollectionReference collection, BuildContext context) {
    showDialog(context: context,barrierDismissible: true,builder:(context)=> AlertDialog(
      content: FutureBuilder(
        future: collection.getDocuments(), builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(!snapshot.hasData)
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                PleaseWait(),
              ],
            );
          final data = snapshot.data.documents;
          return Container(
            height: SizeConfig.blockSizeHorizontal *75,
            width: SizeConfig.screenWidth,
            child: Column(
              children: [
                Container(child: Text("Time table",style: Theme.of(context).textTheme.headline6.copyWith(color: Colors.blueAccent),),),
                SizedBox(height: SizeConfig.safeBlockHorizontal,),
                Expanded(
                  child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context,index)=>Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(data[index]?.data["venue"]??""),
                          Text(data[index]?.data["date"]??""),
                          Text(data[index]?.data["time"]??""),
                          Divider()
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  child: MaterialButton(
                    onPressed: () { Navigator.pop(context); },
                    child: Text("close",style: TextStyle(color: Theme.of(context).primaryColor),),
                  ),
                )
              ],
            ),
          );
      },
      ),
    ));
  }
}
