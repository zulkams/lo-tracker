import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:lo_tracker/screen/keyin_screen.dart';
import 'package:lo_tracker/screen/login_screen.dart';
import 'package:lo_tracker/service/toast.dart';
import 'package:lo_tracker/widget/custom_textfield.dart';

import 'package:location/location.dart' as loc;
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';

class UserHomeScreen extends StatefulWidget {
  UserHomeScreen({super.key});

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  final loc.Location location = loc.Location();

  StreamSubscription<loc.LocationData>? _locationSubscription;

  final TextEditingController _numOf20CrateController = TextEditingController();

  final TextEditingController _numOf30CrateController = TextEditingController();
  final TextEditingController _textFieldController = TextEditingController();

  final TextEditingController _textFieldController30 = TextEditingController();
  String? codeDialog;
  String? valueText;
  bool isOnJob = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isOnJob = false;
    checkOnJobStatusByEmail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("HOME"),
        actions: [GestureDetector(onTap: () => _logout(context), child: Icon(LineAwesomeIcons.alternate_sign_out))],
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // GestureDetector(
          //     onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const KeyInData())),
          //     child: Container(color: Colors.grey, height: MediaQuery.of(context).size.height * 0.08, width: double.infinity, child: Text("Key In Data"))),
          Center(child: Text("WELCOME USER!")),
          _buildForm(),
          ElevatedButton(onPressed: () => !isOnJob ? _listenLocation() : _stopListening(), child: Text(!isOnJob ? "START JOB" : "COMPLETE JOB"))
          // ElevatedButton(onPressed: () => _logout(context), child: Text("Log Out"))
        ],
      )),
    );
  }

  void _logout(context) async {
    CallToast().showToastMessage("Logging Out...");
    await FirebaseAuth.instance.signOut().then((value) => Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()),
        ));
    print("Logged out");
  }

  _buildForm() {
    return Column(children: [
      CustomTextfield(
        "",
        isOnJob ? "User On Job" : "Enter Number of 20KG Crate",
        LineAwesomeIcons.box,
        _numOf20CrateController,
        isEmail: false,
        isEnabled: !isOnJob,
      ),
      const SizedBox(height: 20),

      CustomTextfield(
        "",
        isOnJob ? "User On Job" : "Enter Number of 30KG Crate",
        LineAwesomeIcons.box,
        _numOf30CrateController,
        isEmail: false,
        isEnabled: !isOnJob,
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

  String getCurrentDateTime() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('dd/MM/yyyy HH:mm').format(now);
    return formattedDate;
  }

  void _addData() async {
    User? user = FirebaseAuth.instance.currentUser;
    String currentDate = getCurrentDateTime();
    // final total = getTotal();
    await FirebaseFirestore.instance
        .collection('crates')
        .doc()
        .set({"type": "Plastic Crate", "email": user?.email, "datetime": currentDate, "total20": _numOf20CrateController.text, "total30": _numOf30CrateController.text}, SetOptions(merge: true));
  }

  Future<void> _addMissingData() async {
    User? user = FirebaseAuth.instance.currentUser;
    String currentDate = getCurrentDateTime();
    // final total = getTotal();
    await FirebaseFirestore.instance
        .collection('crates')
        .doc()
        .set({"type": "Missing", "email": user?.email, "datetime": currentDate, "total20": _textFieldController.text, "total30": _textFieldController30.text}, SetOptions(merge: true));
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
      updateOnJobStatusByEmail(user!.email.toString(), 1);

      setState(() {
        isOnJob = true;
        // _numOf20CrateController.clear();
      });
    });
    _addData();
  }

  void updateOnJobStatusByEmail(String email, int status) {
    CollectionReference usersRef = FirebaseFirestore.instance.collection('users');

    usersRef.where('email', isEqualTo: email).get().then((QuerySnapshot querySnapshot) {
      if (querySnapshot.size > 0) {
        String documentId = querySnapshot.docs[0].id;

        usersRef
            .doc(documentId)
            .update({'onjob': status})
            .then((_) => print('User with email $email on job updated successfully!'))
            .catchError((error) => print('Error updating on job status: $error'));

        usersRef
            .doc(documentId)
            .update({'quantity20': int.parse(_numOf20CrateController.text), 'quantity30': int.parse(_numOf30CrateController.text)})
            .then((_) => print('User with email $email on job updated successfully!'))
            .catchError((error) => print('Error updating on job status: $error'));
      } else {
        print('No user found with email $email.');
      }
    }).catchError((error) {
      print('Error retrieving user data: $error');
    });
  }

  _stopListening() {
    User? user = FirebaseAuth.instance.currentUser;
    _locationSubscription?.cancel();
    // _addData();
    updateOnJobStatusByEmail(user!.email.toString(), 0);
    setState(() {
      _locationSubscription = null;
      isOnJob = false;
    });
    _displayTextInputDialog(context);
  }

  void checkOnJobStatusByEmail() {
    User? user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance.collection('users').where('email', isEqualTo: user?.email).get().then((QuerySnapshot querySnapshot) {
      if (querySnapshot.size > 0) {
        Map<String, dynamic> userData = querySnapshot.docs[0].data() as Map<String, dynamic>;
        int onJobValue = userData['onjob'];

        if (onJobValue == 0) {
          // 'onjob' field is equal to 0
          print('User with email is not on the job.');
          setState(() {
            isOnJob = false;
          });
        } else if (onJobValue == 1) {
          // 'onjob' field is equal to 1
          print('User with email is on the job.');
          setState(() {
            isOnJob = true;
          });
        } else {
          // 'onjob' field has a different value
          print('Unknown value for onjob field: $onJobValue');
        }
      } else {
        // No user found with the specified email
        print('No user found with email.');
      }
    }).catchError((error) {
      print('Error retrieving user data: $error');
    });
  }

  // Future<void> getTotal() async {
  //   User? user = FirebaseAuth.instance.currentUser;
  //   FirebaseFirestore.instance.collection('users').where('email', isEqualTo: user?.email).get().then((QuerySnapshot querySnapshot) {
  //     if (querySnapshot.size > 0) {
  //       Map<String, dynamic> userData = querySnapshot.docs[0].data() as Map<String, dynamic>;
  //       int total = userData['quantity20'];
  //       int total30 = userData['quantity30'];

  //       return total;
  //     } else {
  //       // No user found with the specified email
  //       print('No user found with email.');
  //     }
  //   }).catchError((error) {
  //     print('Error retrieving user data: $error');
  //   });
  // }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Got Missing Crate?'),
            content: Column(
              children: [
                TextField(
                  onChanged: (value) {
                    setState(() {
                      valueText = value;
                    });
                  },
                  controller: _textFieldController,
                  decoration: const InputDecoration(hintText: "Enter Missing 20KG Crate"),
                ),
                SizedBox(height: 20),
                TextField(
                  onChanged: (value) {
                    setState(() {
                      valueText = value;
                    });
                  },
                  controller: _textFieldController30,
                  decoration: const InputDecoration(hintText: "Enter Missing 30KG Crate"),
                ),
              ],
            ),
            actions: <Widget>[
              MaterialButton(
                color: Colors.red,
                textColor: Colors.white,
                child: const Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              MaterialButton(
                color: Colors.green,
                textColor: Colors.white,
                child: const Text('CONFIRM'),
                onPressed: () {
                  setState(() {
                    codeDialog = valueText;
                    _addMissingData();
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }
}
