import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
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
                children: [_buildForm(), SizedBox(height: 40), CustomButton("Register")],
              )),
              CustomToolbar(),
            ],
          )),
    ));
  }

  _buildForm() {
    return Column(
      children: const [
        CustomTextfield(
          "Full Name",
          "Enter Your Full Name",
          LineAwesomeIcons.user,
        ),
        SizedBox(height: 20),
        CustomTextfield(
          "Phone Number",
          "Enter Your Phone Number",
          LineAwesomeIcons.phone,
          isNumber: true,
          isPhone: true,
        ),
        SizedBox(height: 20),
        CustomTextfield(
          "Email",
          "Enter Your Email",
          LineAwesomeIcons.envelope,
          isEmail: true,
        ),
        SizedBox(height: 20),
        CustomTextfield(
          "Password",
          "Enter Your Password",
          LineAwesomeIcons.lock,
          hasSuffix: true,
        )
      ],
    );
  }
}
