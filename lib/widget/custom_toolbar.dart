import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class CustomToolbar extends StatelessWidget {
  CustomToolbar(this.toolbarTitle, {super.key});

  String toolbarTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.black12,
            width: 1.5,
          ),
        ),
      ),
      width: MediaQuery.of(context).size.width,
      height: 70,
      child: Center(
        child: Row(
          children: [
            SizedBox(
              width: 60,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  LineAwesomeIcons.arrow_left,
                  size: 30,
                ),
              ),
            ),
            Expanded(
              child: Text(
                toolbarTitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(width: 60),
          ],
        ),
      ),
    );
  }
}
