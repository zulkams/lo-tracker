import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:lo_tracker/widget/custom_textfield.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';

class KeyInData extends StatefulWidget {
  const KeyInData({super.key});

  @override
  State<KeyInData> createState() => _KeyInDataState();
}

class _KeyInDataState extends State<KeyInData> {
  final TextEditingController _numOfCrateController = TextEditingController();
  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData>? _locationSubscription;
  // User? user =

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("KEY IN DATA"),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              _buildForm(),
              Center(child: ElevatedButton(onPressed: () => _listenLocation(), child: Text("Turn On Live Tracking"))),
            ],
          ),
        ));
  }

  _buildForm() {
    return Column(children: [
      CustomTextfield(
        "",
        "Enter Number of Crate (KG)",
        LineAwesomeIcons.box,
        _numOfCrateController,
        isEmail: false,
      ),
      const SizedBox(height: 20),
      // CustomTextfield(
      //   "Password",
      //   "Enter Your Password",
      //   LineAwesomeIcons.lock,
      //   _passwordController,
      //   hasSuffix: true,
      // ),
    ]);
  }

  Future<void> _listenLocation() async {
    User? user = FirebaseAuth.instance.currentUser;
    _locationSubscription = location.onLocationChanged.handleError((onError) {
      print(onError);
      _locationSubscription?.cancel();
      setState(() {
        _locationSubscription = null;
      });
    }).listen((loc.LocationData currentlocation) async {
      await FirebaseFirestore.instance
          .collection('location')
          .doc(user?.email)
          .set({'latitude': currentlocation.latitude, 'longitude': currentlocation.longitude, 'name': user?.email}, SetOptions(merge: true));
    });
  }
}
