import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:lo_tracker/screen/cratelist_screen.dart';
import 'package:lo_tracker/screen/tracking_screen.dart';

class CheckUserScreen extends StatefulWidget {
  const CheckUserScreen({super.key});

  @override
  State<CheckUserScreen> createState() => _CheckUserScreenState();
}

class _CheckUserScreenState extends State<CheckUserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("ALL USER"),
      ),
      body: SingleChildScrollView(child: UsersColumn()),
    );
  }
}

class UsersColumn extends StatefulWidget {
  @override
  _UsersColumnState createState() => _UsersColumnState();
}

class _UsersColumnState extends State<UsersColumn> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').where('type', isEqualTo: 2).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        List<Container> userContainers = snapshot.data!.docs.map((doc) {
          Map<String, dynamic> userData = doc.data() as Map<String, dynamic>;

          return Container(
            width: double.infinity,
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CrateListScreen(email: userData['email']))),
                  child: CircleAvatar(
                    radius: 30,
                  ),
                ),
                Column(
                  children: [
                    (userData['onjob'] == 1) ? Text("Active") : Text("Inactive"),
                    Text(
                      '${userData['full_name']}',
                      style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${userData['id']}',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ],
                ),
                (userData['onjob'] == 1)
                    ? SizedBox(
                        width: 20,
                        child: GestureDetector(
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => TrackingScreen(
                                        email: userData['email'], name: userData['full_name'], id: userData['id'], quantity20: userData['quantity20'], quantity30: userData['quantity30'], type: 1))),
                            child: Icon(LineAwesomeIcons.map_marker)),
                      )
                    : SizedBox(
                        width: 20,
                      )
              ],
            ),
          );
        }).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: userContainers,
        );
      },
    );
  }
}
