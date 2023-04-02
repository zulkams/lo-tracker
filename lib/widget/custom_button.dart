import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/colors.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      height: 50,
      child: ElevatedButton(
          onPressed: () {
            print('loll');
          },
          style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(AppColors.secondaryColor), shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)))),
          child: Text(
            title,
            style: GoogleFonts.lato(fontSize: 16, textStyle: TextStyle(fontWeight: FontWeight.bold)),
          )),
    );
  }
}
