// ignore_for_file: sort_child_properties_last, use_build_context_synchronously, camel_case_types, prefer_const_constructors, use_key_in_widget_constructors, unused_local_variable, prefer_typing_uninitialized_variables, avoid_print, prefer_final_fields

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../utility/routes.dart';

class profilePage extends StatefulWidget {
  @override
  State<profilePage> createState() => _profilePageState();
}

class _profilePageState extends State<profilePage> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  String _uid = "";
  String _url = "";

  @override
  initState() {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final User? user = auth.currentUser;
    final uid = user!.uid;
    print(uid);

    setState(() {
      _uid = uid;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(_uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return const Text("Document does not exist");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          return SafeArea(
            child: Scaffold(
              body: Column(
                children: [
                  Container(
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(30.0),
                        bottomRight: Radius.circular(30.0),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 7,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        "MeetMeFit",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 30,
                            color: Color.fromRGBO(243, 144, 62, 1)),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  Container(
                    child: Image.network(
                      "${data['url']}",
                    ),
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromRGBO(112, 112, 112, 1),
                      ),
                      borderRadius: BorderRadius.circular(75),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text("${data['name']}",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      )),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text("${data['about']}",
                          style: TextStyle(
                            fontSize: 17,
                          )),
                    ),
                    height: 150,
                    width: 310,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 2.0,
                        color: const Color.fromRGBO(112, 112, 112, 1),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 70,
                  ),
                  SizedBox(
                      width: 110,
                      height: 40,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            primary: Colors.white,
                            side: const BorderSide(
                              width: 1.5,
                              color: Colors.black87,
                            ),
                          ),
                          onPressed: () async {
                            await FirebaseAuth.instance.signOut();
                            Navigator.pushReplacementNamed(
                                context, MyRoutes.loginPage);
                            print("${data['url']}");
                          },
                          child: const Text(
                            "Logout",
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 17,
                            ),
                          ))),
                ],
              ),
            ),
          );
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
