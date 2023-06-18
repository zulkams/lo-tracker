import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:lo_tracker/screen/tracking_screen.dart';

class CrateListScreen extends StatefulWidget {
  CrateListScreen({super.key, required this.email});

  String email;

  @override
  State<CrateListScreen> createState() => _CrateListScreenState();
}

class _CrateListScreenState extends State<CrateListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("CRATE LIST"),
      ),
      body: SingleChildScrollView(child: ListColumn(email: widget.email)),
    );
  }
}

class ListColumn extends StatefulWidget {
  ListColumn({super.key, required this.email});

  String email;
  @override
  _UsersColumnState createState() => _UsersColumnState();
}

class _UsersColumnState extends State<ListColumn> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('crates').where('email', isEqualTo: widget.email).snapshots(),
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // GestureDetector(
                //   onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CrateListScreen())),
                //   child: CircleAvatar(
                //     radius: 30,
                //   ),
                // ),
                Column(
                  children: [
                    Text(
                      '${userData['type']}',
                      style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '20KG: ${userData['total20']}',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                    Text(
                      '30KG: ${userData['total30']}',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ],
                ),
                // GestureDetector(
                //     onTap: () => Navigator.push(
                //         context,
                //         MaterialPageRoute(
                //             builder: (context) => TrackingScreen(
                //                   email: userData['email'],
                //                   name: userData['full_name'],
                //                   id: userData['id'],
                //                   quantity: userData['quantity'],
                //                 ))),
                //     child: Icon(LineAwesomeIcons.map_marker))
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
