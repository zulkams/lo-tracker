import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:lo_tracker/constants/colors.dart';
import 'package:lo_tracker/screen/register_screen.dart';
import 'package:lo_tracker/widget/custom_button.dart';
import 'package:lo_tracker/widget/custom_textfield.dart';
import 'package:lo_tracker/widget/screen_layout.dart';
import 'package:logger/logger.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final logger = Logger();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: ScreenLayout(
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  color: AppColors.secondaryColor,
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: MediaQuery.of(context).size.width * 0.3,
                ),
                const SizedBox(height: 50),
                _buildForm(),
                const SizedBox(height: 30),
                GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen())),
                  child: Text(
                    "Don't have an account? Register now!",
                    style: GoogleFonts.lato(color: AppColors.primaryColor, textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildForm() {
    return Column(
      children: [
        const CustomTextfield(
          "Email",
          "Enter Your Email",
          LineAwesomeIcons.envelope,
          isEmail: true,
        ),
        const SizedBox(height: 20),
        const CustomTextfield(
          "Password",
          "Enter Your Password",
          LineAwesomeIcons.lock,
          hasSuffix: true,
        ),
        const SizedBox(height: 40),
        CustomButton("Login")
      ],
    );
  }
}
