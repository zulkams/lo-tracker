import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic> userData = {};
  User? user = FirebaseAuth.instance.currentUser;
  String? userEmail;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    userEmail = user?.email;
    fetchUserData(userEmail);
    isLoading = true;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text("PROFILE"),
        ),
        body: Center(
            child: isLoading
                ? CircularProgressIndicator()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                        height: MediaQuery.of(context).size.height * 0.4,
                        width: double.infinity,
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)]),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 50,
                            ),
                            // Text(user?.email.toString())
                            SizedBox(height: 20),
                            Text(
                              userData['full_name'],
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 20),
                            Text(userData['id']),
                            userData['type'] == 2 ? Text('Trucker') : Text('Admin'),
                            Text("0${userData['phone']}"),
                            Text(userData['email']),
                          ],
                        )),
                  )));
  }

  Future<void> fetchUserData(String? email) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: email).limit(1).get();

      if (snapshot.docs.isNotEmpty) {
        setState(() {
          isLoading = false;
          userData = snapshot.docs[0].data() as Map<String, dynamic>;
        });
      }
    } catch (e) {
      print('Error retrieving user data: $e');
    }
  }
}
