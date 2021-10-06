import 'dart:ui';

import 'package:emedic/utils/enumeration.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class OrderAnimation extends StatefulWidget {
  final OrderStatus orderStatus;
  final LatLng drone;
  final LatLng location;

  const OrderAnimation({Key key, this.orderStatus, this.drone, this.location})
      : super(key: key);

  @override
  _OrderAnimationState createState() => _OrderAnimationState();
}

class _OrderAnimationState extends State<OrderAnimation> {
  GoogleMapController _controller;

  CameraPosition _kGooglePlex;

  BitmapDescriptor _customIcon;
  @override
  void initState() {
    super.initState();

    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(3, 3)),
            'assets/images/drone_marker.png')
        .then((d) {
      if (mounted) {
        setState(() {
          _customIcon = d;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderStatus = widget.orderStatus;
    final latLng = widget.drone;
    String flare;
    String animation;
    Widget customWidget;
    _kGooglePlex = CameraPosition(
      target: latLng,
      zoom: 12.4746,
    );

    if (_controller != null)
      _controller.animateCamera(CameraUpdate.newCameraPosition(_kGooglePlex));

    switch (orderStatus) {
      case OrderStatus.waiting:
        flare = "order_loading";
        animation = "Loading";
        break;
      case OrderStatus.paid:
        flare = "accepted";
        animation = "Pilldrop Opacity";
        break;
      case OrderStatus.accepted:
        flare = "payment_pending";
        animation = "animate";
        break;
      case OrderStatus.onTheWay:
        customWidget = Container(
          child: GoogleMap(
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller = controller;
              },
              polylines: {
                Polyline(
                    polylineId: PolylineId("polyline"),
                    points: [widget.drone, widget.location],
                    visible: true,
                    color: Colors.black,
                    width: 2)
              },
              markers: {
                Marker(
                    markerId: MarkerId("location"), position: widget.location),
                Marker(
                    markerId: MarkerId("live_track"),
                    position: widget.drone,
                    icon: _customIcon)
              },
              gestureRecognizers: Set()
                ..add(Factory<PanGestureRecognizer>(
                    () => PanGestureRecognizer()))),
        );
        break;
      case OrderStatus.completed:
      case OrderStatus.cancelled:
        customWidget = Stack(
          alignment: Alignment.center,
          children: <Widget>[
            AbsorbPointer(
              absorbing: true,
              child: GoogleMap(
                initialCameraPosition: CameraPosition(
                  zoom: 14.5,
                  target: widget.location,
                ),
                markers: {
                  Marker(
                      markerId: MarkerId("MyLocation"),
                      position: widget.location)
                },
              ),
            ),
//            Positioned.fill(
//              child: BackdropFilter(
//                child: Container(
//                  color: Colors.black.withOpacity(0),
//                ),
//                filter: ImageFilter.blur(sigmaX: 1, sigmaY: 1),
//              ),
//            ),
          ],
        );
        break;
    }

    if (orderStatus == OrderStatus.accepted ||
        orderStatus == OrderStatus.waiting || orderStatus == OrderStatus.paid) {
      flare = "assets/flare/$flare.flr";
      return Container(
        height: 150,
        child: FlareActor(
          flare,
          fit: BoxFit.contain,
          animation: animation,
        ),
      );
    } else
      return customWidget;
  }
}
