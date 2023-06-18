import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:lo_tracker/constants/colors.dart';
import 'package:lo_tracker/screen/admin_home_screen.dart';
import 'package:lo_tracker/screen/navbar.dart';
import 'package:lo_tracker/screen/register_screen.dart';
import 'package:lo_tracker/screen/tracking_screen.dart';
import 'package:lo_tracker/screen/user_home_screen.dart';
import 'package:lo_tracker/service/toast.dart';
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
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final auth = FirebaseAuth.instance;
  final User? user = FirebaseAuth.instance.currentUser;
  bool? isLoading;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: ScreenLayout(
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Image(image: AssetImage('assets/logo.png')),
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
                  const SizedBox(height: 40),
                  _buildButton("Login"),
                ],
              ),
            ),
          ),
        ),
        Visibility(
          visible: isLoading!,
          child: Container(
            height: double.infinity,
            width: double.infinity,
            color: Colors.black26,
            child: Center(child: CircularProgressIndicator()),
          ),
        )
      ]),
    );
  }

  _buildForm() {
    return Column(children: [
      CustomTextfield(
        "Email",
        "Enter Your Email",
        LineAwesomeIcons.envelope,
        _emailController,
        isEmail: true,
      ),
      const SizedBox(height: 20),
      CustomTextfield(
        "Password",
        "Enter Your Password",
        LineAwesomeIcons.lock,
        _passwordController,
        hasSuffix: true,
      ),
    ]);
  }

// CustomButton(
  //   "Login",
  //   onPressed: _registerUser(),
  // )
  _buildButton(String? title) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.7,
      height: 50,
      child: ElevatedButton(
          onPressed: () async {
            String status = await _login(_emailController.text, _passwordController.text);
            setState(() {
              isLoading = true;
            });

            if (status == "success") {
              setState(() {
                isLoading = false;
              });
              CallToast().showToastMessage("Logging In..");
              navigateToNextScreen();

              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (context) => const TrackingScreen()),
              // );
            } else {
              setState(() {
                isLoading = false;
              });
              CallToast().showToastMessage(status);
            }
            // _registerUser();
          },
          style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(AppColors.secondaryColor), shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)))),
          child: Text(
            title!,
            style: GoogleFonts.lato(fontSize: 16, textStyle: TextStyle(fontWeight: FontWeight.bold)),
          )),
    );
  }

  Future<String> _login(String email, String password) async {
    try {
      // Perform the login operation, such as calling an API or authenticating with Firebase
      // Replace this with your own login implementation

      // Example: Authenticate with Firebase Authentication
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // If the login is successful, you can perform further actions
      // or navigate to a new screen
      print('Logged in successfully');
      return "success";
    } catch (error) {
      // Handle any errors that occurred during the login process
      print('Error logging in: $error');
      print(email + password);
      return error.toString();
      // Optional: Rethrow the error to handle it elsewhere
    }
  }

  void navigateToNextScreen() async {
    await Future.delayed(Duration(seconds: 2)); // Simulating a splash screen delay

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection('users').where('email', isEqualTo: user.email).limit(1).get();

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
}
