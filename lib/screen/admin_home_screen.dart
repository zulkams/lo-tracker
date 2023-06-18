import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:lo_tracker/screen/checkuser.dart';
import 'package:lo_tracker/screen/login_screen.dart';
import 'package:lo_tracker/service/toast.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("HOME"),
        actions: [GestureDetector(onTap: () => _logout(context), child: Icon(LineAwesomeIcons.alternate_sign_out))],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "ADMIN",
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const CheckUserScreen())),
                  child: Container(
                      child: Center(child: Text("CHECK DATA", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold))),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)]),
                      height: MediaQuery.of(context).size.height * 0.1,
                      width: double.infinity))
            ],
          ),
        ),
      ),
    );
  }

  void _logout(context) async {
    CallToast().showToastMessage("Logging Out...");
    await FirebaseAuth.instance.signOut().then((value) => Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => LoginScreen()),
        ));
    print("Logged out");
  }
}
