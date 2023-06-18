import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lo_tracker/screen/admin_home_screen.dart';
import 'package:lo_tracker/screen/login_screen.dart';
import 'package:lo_tracker/screen/navbar.dart';
import 'package:lo_tracker/screen/tracking_screen.dart';
import 'package:lo_tracker/screen/user_home_screen.dart';
import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  final loc.Location location = loc.Location();
  StreamSubscription<loc.LocationData>? _locationSubscription;

  @override
  void initState() {
    super.initState();
    _getLocation();
    navigateToNextScreen();
  }

  void navigateToNextScreen() async {
    await Future.delayed(Duration(seconds: 2)); // Simulating a splash screen delay

    if (user != null) {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: user?.email).limit(1).get();

      if (snapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = snapshot.docs[0];
        int userType = (userDoc.data() as Map<String, dynamic>?)?['type'];

        Widget nextScreen;
        if (userType == 1) {
          // User with type 1 (admin), navigate to ScreenA
          print("ADMIN");
          nextScreen = NavBar(type: 1);
        } else {
          // Default screen if userType is 2 (normal user)
          print("USER");
          nextScreen = NavBar(type: 2);
        }

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => nextScreen),
        );
      } else {
        // User document not found, navigate to LoginScreen
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );
      }
    } else {
      // User is not logged in, navigate to LoginScreen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  _getLocation() async {
    try {
      final loc.LocationData _locationResult = await location.getLocation();
      await FirebaseFirestore.instance
          .collection('location')
          .doc(user?.email)
          .set({'latitude': _locationResult.latitude, 'longitude': _locationResult.longitude, 'name': user?.email}, SetOptions(merge: true));
    } catch (e) {
      print(e);
    }
  }

  Future<void> _listenLocation() async {
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
          .set({'latitude': currentlocation.latitude, 'longitude': currentlocation.longitude, 'name': 'john'}, SetOptions(merge: true));
    });
  }

  _stopListening() {
    _locationSubscription?.cancel();
    setState(() {
      _locationSubscription = null;
    });
  }
}
