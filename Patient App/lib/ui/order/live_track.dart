import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emedic/models/order.dart';
import 'package:emedic/utils/size_config.dart';
import 'package:emedic/utils/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LiveTrack extends StatefulWidget {
  final DocumentReference order;

  const LiveTrack({Key key,@required this.order}) : super(key: key);
  @override
  _LiveTrackState createState() => _LiveTrackState();
}

class _LiveTrackState extends State<LiveTrack> {
  GoogleMapController _controller;
  CameraPosition _cameraPosition;
  BitmapDescriptor _customIcon;

  @override
  void initState() {
    super.initState();
    _cameraPosition = CameraPosition(
      zoom: 8,
      target: LatLng(7.8731,80.7718)
    );

    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(3, 3)),
        'assets/images/drone_marker.png')
        .then((d) {
          if(mounted){
            setState(() {
              _customIcon = d;
            });
          }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("LiveTrack"),
      ),
      body: Container(
        child: StreamBuilder<DocumentSnapshot>(
          stream: widget.order.snapshots(),
          builder: (context, snapshot) {
            if(!snapshot.hasData)
              return LoadingWidget();

            Order order = Order.fromMap(snapshot.data.data);

            if(_controller!=null){
              _controller.animateCamera(CameraUpdate.newCameraPosition(
                CameraPosition(
                  zoom: 15,
                  target: order.liveTrack
                )
              ));
            }
            final distanceStyle = TextStyle(fontSize: SizeConfig.blockSizeHorizontal * 3.5);
            final titleStyle = TextStyle(fontSize: SizeConfig.blockSizeHorizontal * 5,fontWeight: FontWeight.bold);
            final etaStyle = TextStyle(fontSize: SizeConfig.blockSizeHorizontal * 3,fontWeight: FontWeight.bold,color: Colors.grey);
            return Stack(
              children: <Widget>[
                GoogleMap(
                  initialCameraPosition: _cameraPosition,
                  polylines: {
                    Polyline(polylineId: PolylineId("drone"),points: [
                      order.liveTrack,order.location
                    ],width: 2)
                  },
                  markers: {
                    Marker(markerId: MarkerId("drone"),position: order.liveTrack,icon: _customIcon),
                    Marker(markerId: MarkerId("location"),position: order.location),
                  },
                  onMapCreated: (GoogleMapController controller){
                    setState(() {
                      _controller = controller;
                    });
                  },
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: SizeConfig.screenWidth,
                    height: SizeConfig.blockSizeHorizontal * 35,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(35)
                    ),
                    child: Column(
                                children: [
                                  SizedBox(height: SizeConfig.blockSizeHorizontal *3,),
                                  Text("Live tracking information",style: titleStyle,),
                                  SizedBox(height: SizeConfig.blockSizeHorizontal *5,),
                                  FutureBuilder(
                                    future: Geolocator().distanceBetween(order.liveTrack.latitude, order.liveTrack.longitude,order.location.latitude, order.location.longitude), builder: (BuildContext context, AsyncSnapshot<double> snapshot) {
                                      String text;
                                      if(!snapshot.hasData)
                                        text = "";
                                      else{
                                        text = snapshot.data.toStringAsFixed(2);
                                      }
                                      return Text("Distance: $text meters",style:distanceStyle);
                                  },
                                  ),
                                  Text("ETA: 1000",style: etaStyle,),
                                  Spacer(),
                                ],
                              ),
                  ),
                ),
              ],
            );
          }
        ),
      ),
    );
  }
}
