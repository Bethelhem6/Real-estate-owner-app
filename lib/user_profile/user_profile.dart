import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../authenthication/login.dart';

// ignore: camel_case_types
class user_profile extends StatefulWidget {
  const user_profile({super.key});

  @override
  State<user_profile> createState() => _user_profileState();
}

// ignore: camel_case_types
class _user_profileState extends State<user_profile> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _uid = "";
  String _name = "";
  String _email = "";
  String _image = "";

  void _getData() async {
    User? user = _auth.currentUser;
    _uid = user!.uid;

    final DocumentSnapshot userDocs =
        await FirebaseFirestore.instance.collection("users").doc(_uid).get();
    setState(() {
      _name = userDocs.get('name');
      _email = userDocs.get('email');
      _image = userDocs.get('image');
    });
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        toolbarHeight: 70,
        title: const Text("My Profile"),
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(20),
              bottomLeft: Radius.circular(20)),
        ),
      ),
      body: ListView(
        children: <Widget>[
          Container(
            height: 250,
            // decoration: const BoxDecoration(
            //   gradient: LinearGradient(
            //     colors: [Colors.black12, Colors.white],
            //     begin: Alignment.centerLeft,
            //     end: Alignment.centerRight,
            //     stops: [0.5, 0.9],
            //   ),
            // ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    // CircleAvatar(
                    //   backgroundColor: Colors.red.shade300,
                    //   minRadius: 35.0,
                    //   child: Icon(
                    //     Icons.call,
                    //     size: 30.0,
                    //   ),
                    // ),

                    CircleAvatar(
                      backgroundColor: Colors.white70,
                      minRadius: 80.0,
                      child: CircleAvatar(
                        radius: 75.0,
                        backgroundImage: NetworkImage(_image),
                      ),
                    ),
                  ],
                ),
                Text(
                  _name,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal),
                  onPressed: () {},
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit profile'),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 30),
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),

//  height: 100.0,
                  // color: Colors.grey[100],
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  margin: const EdgeInsets.all(5),
                  child: ListTile(
                    leading: const Icon(
                      Icons.person,
                      color: Colors.teal,
                    ),
                    title: const Text(
                      "User Name",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      _name,
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),

                // Divider(),

                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  //  color: Colors.grey[100],
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  margin: const EdgeInsets.all(5),
                  child: const ListTile(
                    leading: Icon(
                      Icons.phone,
                      color: Colors.deepOrange,
                    ),
                    title: Text(
                      'Phone number',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      '0901480166',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                // Divider(),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),

                  //  color: Colors.grey[100],
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  margin: const EdgeInsets.all(5),
                  child: ListTile(
                    leading: const Icon(
                      Icons.email,
                      color: Colors.blue,
                    ),
                    title: const Text(
                      'Email',
                      style: TextStyle(
                        // color: Colors.teal,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      _email,
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),

                  //  color: Colors.grey[100],
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  margin: const EdgeInsets.all(5),

                  child: const ListTile(
                    leading: Icon(
                      Icons.location_city_rounded,
                      color: Colors.teal,
                    ),
                    title: Text(
                      'Adress',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Addis Ababa',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),

                  //  color: Colors.grey[100],
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  margin: const EdgeInsets.all(5),

                  child: ListTile(
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();

                      Navigator.pop(context);

                     

                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    },
                    leading: const Icon(
                      Icons.logout,
                      color: Colors.red,
                    ),
                    title: const Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
