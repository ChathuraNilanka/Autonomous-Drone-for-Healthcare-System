import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emedic/resources/repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AppRatingBar extends StatelessWidget {
  final DocumentReference documentReference;

  const AppRatingBar({Key key, this.documentReference}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: documentReference.get(),
        builder: (context, snapshot) {
          if(!snapshot.hasData)
            return Container();

          double rating = 0;
          if(snapshot.data["rating"] != null)
            rating = double.parse(snapshot.data["rating"].toString());
          return RatingBar(
            initialRating: rating,
            itemSize: 25,
            itemCount: 5,
            itemBuilder: (context, index) {
              switch (index) {
                case 0:
                  return Icon(
                    Icons.sentiment_very_dissatisfied,
                    color: Colors.red,
                  );
                case 1:
                  return Icon(
                    Icons.sentiment_dissatisfied,
                    color: Colors.redAccent,
                  );
                case 2:
                  return Icon(
                    Icons.sentiment_neutral,
                    color: Colors.amber,
                  );
                case 3:
                  return Icon(
                    Icons.sentiment_satisfied,
                    color: Colors.lightGreen,
                  );
                case 4:
                  return Icon(
                    Icons.sentiment_very_satisfied,
                    color: Colors.green,
                  );
                default:
                  return Container();
              }
            },
            onRatingUpdate: (rating) {
              Repository().updateOrderRating(documentReference, rating).then((_){
                Fluttertoast.showToast(
                    msg: "Feedback changed",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIosWeb: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0
                );
              });
            },
          );
        }
      ),
    );
  }
}
