import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/colors.dart';

class CustomButton extends StatelessWidget {
  CustomButton(this.title, {this.onPressed});

  final String title;
  final dynamic onPressed;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      height: 50,
      child: ElevatedButton(
          onPressed: () {
            onPressed;
          },
          style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(AppColors.secondaryColor), shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)))),
          child: Text(
            title,
            style: GoogleFonts.lato(fontSize: 16, textStyle: TextStyle(fontWeight: FontWeight.bold)),
          )),
    );
  }
}
