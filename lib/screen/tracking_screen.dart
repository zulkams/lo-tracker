import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lo_tracker/widget/custom_toolbar.dart';
import 'package:lo_tracker/widget/screen_layout.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

import 'package:location/location.dart' as loc;

class TrackingScreen extends StatefulWidget {
  TrackingScreen({super.key, required this.email, required this.name, required this.id, required this.quantity20, required this.quantity30, this.type});

  String email;
  String name, id;
  int quantity20, quantity30;
  int? type;

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  final loc.Location location = loc.Location();
  late GoogleMapController _controller;
  bool _added = false;
  // static final LatLng _kMapCenter = LatLng(19.018255973653343, 72.84793849278007);

  String? trackEmail;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.type == 1) {
      setState(() {
        trackEmail = widget.email;
      });
    } else {
      setState(() {
        trackEmail = user?.email;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("TRACK TRUCK"),
        ),
        body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Stack(children: [
              ScreenLayout(
                  padding: 0.0,
                  SlidingUpPanel(
                    minHeight: widget.type == 1 ? 100 : 0,
                    panel: Center(
                        child: widget.type == 1
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.name,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    widget.id,
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    "20KG: " + widget.quantity20.toString(),
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    "30KG: " + widget.quantity30.toString(),
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ],
                              )
                            : null),
                    collapsed: widget.type == 1
                        ? Container(
                            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15))),
                            child: Center(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  "INFO",
                                  style: TextStyle(fontSize: 24),
                                ),
                              ],
                            )),
                          )
                        : null,
                    body: StreamBuilder(
                        stream: FirebaseFirestore.instance.collection('location').snapshots(),
                        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (_added) {
                            mymap(snapshot);
                          }
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          }
                          return GoogleMap(
                            initialCameraPosition: CameraPosition(
                                target: LatLng(
                                  snapshot.data!.docs.singleWhere((element) => element.id == trackEmail)['latitude'],
                                  snapshot.data!.docs.singleWhere((element) => element.id == trackEmail)['longitude'],
                                ),
                                zoom: 14.47),
                            markers: {
                              Marker(
                                  position: LatLng(
                                    snapshot.data!.docs.singleWhere((element) => element.id == trackEmail)['latitude'],
                                    snapshot.data!.docs.singleWhere((element) => element.id == trackEmail)['longitude'],
                                  ),
                                  markerId: MarkerId('id'),
                                  icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta)),
                            },
                          );
                        }),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(15), topRight: Radius.circular(15)),
                  )),
              // CustomToolbar("TRACK TRUCK")
            ]),
          ),
        ));
  }

  Future<void> mymap(AsyncSnapshot<QuerySnapshot> snapshot) async {
    await _controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(
          snapshot.data!.docs.singleWhere((element) => element.id == trackEmail)['latitude'],
          snapshot.data!.docs.singleWhere((element) => element.id == trackEmail)['longitude'],
        ),
        zoom: 14.47)));
  }
}
