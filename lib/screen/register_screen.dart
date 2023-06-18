import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:lo_tracker/model/register_model.dart';
import 'package:lo_tracker/service/toast.dart';
import 'package:lo_tracker/widget/custom_button.dart';
import 'package:lo_tracker/widget/custom_textfield.dart';
import 'package:lo_tracker/widget/custom_toolbar.dart';
import 'package:lo_tracker/widget/screen_layout.dart';

import '../constants/colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final auth = FirebaseAuth.instance;
  bool _isLoading = false;

  // final usersRef = FirebaseFirestore.instance.collection('users').withConverter<RegisterModel>(
  //       fromFirestore: (snapshot, _) => RegisterModel.fromJson(snapshot.data()!),
  //       toFirestore: (user, _) => user.toJson(),
  //     );

  @override
  void initState() {
    // TODO: implement initState
    _isLoading = false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Stack(
              children: [
                ScreenLayout(Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [_buildForm(), SizedBox(height: 40), _buildButton("Register")],
                )),
                _isLoading
                    ? Container(
                        color: Colors.white38,
                        child: Center(child: CircularProgressIndicator()),
                      )
                    : SizedBox(),
                CustomToolbar("REGISTER"),
              ],
            )),
      ),
    );
  }

  _buildForm() {
    return Column(
      children: [
        CustomTextfield(
          "Full Name",
          "Enter Your Full Name",
          LineAwesomeIcons.user,
          _nameController,
        ),
        SizedBox(height: 20),
        CustomTextfield(
          "Phone Number",
          "Enter Your Phone Number",
          LineAwesomeIcons.phone,
          _phoneController,
          isNumber: true,
          isPhone: true,
        ),
        SizedBox(height: 20),
        CustomTextfield(
          "Email",
          "Enter Your Email",
          LineAwesomeIcons.envelope,
          _emailController,
          isEmail: true,
        ),
        SizedBox(height: 20),
        CustomTextfield(
          "Password",
          "Enter Your Password",
          LineAwesomeIcons.lock,
          _passwordController,
          hasSuffix: true,
        )
      ],
    );
  }

  _buildButton(String? title) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      height: 50,
      child: ElevatedButton(
          onPressed: () async {
            String status = await _addUser(_nameController.text, _phoneController.text, _emailController.text, _passwordController.text);

            if (status == "success") {
              _registerUser(_emailController.text, _passwordController.text)
                  .then((value) => CallToast().showToastMessage("User registered. Please wait for verification."))
                  .then((value) => _clearRegisterField().then((value) => Navigator.pop(context)));
            } else {
              _deleteUserByEmail(_emailController.text);
            }
            // addUser();
          },
          style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(AppColors.secondaryColor), shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)))),
          child: Text(
            title!,
            style: GoogleFonts.lato(fontSize: 16, textStyle: TextStyle(fontWeight: FontWeight.bold)),
          )),
    );
  }

  Future<void> _registerUser(String email, String password) async {
    try {
      final UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Registration successful
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  String generateID() {
    Random random = Random();
    String alphabets = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    int randomNumber = random.nextInt(900000) + 100000;
    String id = 'KS' + alphabets[random.nextInt(alphabets.length)] + randomNumber.toString();
    return id;
  }

  Future<String> _addUser(String fullname, String phone, String email, String password) async {
    try {
      String id = generateID();
      final DocumentReference documentReference = await users.add({
        'full_name': _nameController.text,
        'phone': _phoneController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        'type': 2,
        'status': 0,
        'onjob': 0,
        'id': id,
      });

      print("User Added");
      return "success";
    } catch (error) {
      print("Failed to add user: $error");
      throw error; // Optional: Rethrow the error to handle it elsewhere
    }
  }

  Future<void> _deleteUserByEmail(String email) async {
    QuerySnapshot querySnapshot = await users.where('email', isEqualTo: email).get();

    if (querySnapshot.docs.isNotEmpty) {
      for (DocumentSnapshot document in querySnapshot.docs) {
        await document.reference.delete();
      }
      print('User(s) deleted');
    } else {
      print('User not found');
    }
  }

  Future<void> _clearRegisterField() async {
    setState(() {
      _nameController.clear();
      _phoneController.clear();
      _emailController.clear();
      _passwordController.clear();
    });
  }
}
