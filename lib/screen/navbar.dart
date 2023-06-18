import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:lo_tracker/screen/admin_home_screen.dart';
import 'package:lo_tracker/screen/profile_screen.dart';
import 'package:lo_tracker/screen/tracking_screen.dart';
import 'package:lo_tracker/screen/user_home_screen.dart';

class NavBar extends StatefulWidget {
  NavBar({required this.type});

  int type;

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  User? user = FirebaseAuth.instance.currentUser;
  int _currentIndex = 0;
  var typee = 1;
  Widget? homePage;
  Widget? secondPage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    typee = widget.type;
    if (typee == 1) {
      homePage = AdminHomeScreen();
      secondPage = ProfileScreen();
    } else {
      homePage = UserHomeScreen();
      secondPage = TrackingScreen(
        email: user!.email.toString(),
        name: "",
        id: "",
        quantity20: 0,
        quantity30: 0,
        type: 2,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _pages = [
      homePage!,
      secondPage!,
      ProfileScreen(),
    ];
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: (typee == 1)
              ? [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Profile',
                  ),
                ]
              : [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.map),
                    label: 'Track',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Profile',
                  ),
                ]),
      body: _pages[_currentIndex],
    );
  }
}
