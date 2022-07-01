// ignore_for_file: file_names, camel_case_types, prefer_const_constructors_in_immutables, prefer_const_constructors, avoid_print, invalid_return_type_for_catch_error, deprecated_member_use, avoid_init_to_null, unused_element, sort_child_properties_last, unused_field, unnecessary_this, unused_catch_clause, empty_catches, unused_local_variable, use_build_context_synchronously, await_only_futures

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:meetmefit/utility/routes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';

class createProfilePage extends StatefulWidget {
  createProfilePage({Key? key}) : super(key: key);

  @override
  State<createProfilePage> createState() => _createProfilePageState();
}

class _createProfilePageState extends State<createProfilePage> {
  final _formKey = GlobalKey<FormState>();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  String name = '';
  String about = '';
  String _uid = "";
  String _url = "";
  File? _image;

  TextEditingController nameController = TextEditingController();
  TextEditingController aboutController = TextEditingController();

  Future getImage() async {
    final image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, maxHeight: 150, maxWidth: 150);
    if (image == null) return;

    final tempImage = File(image.path);
    setState(() {
      this._image = tempImage;
    });
  }

  Future uploadImage() async {
    final metadata = SettableMetadata(contentType: "image");
    Reference firebaseStorageRef = FirebaseStorage.instance.ref().child(_uid);
    UploadTask uploadTask = firebaseStorageRef.putFile(_image!, metadata);

    TaskSnapshot taskSnapshot = await uploadTask;
    var url = await taskSnapshot.ref.getDownloadURL().toString();
    setState(() {
      _url = url;
    });
  }

  @override
  void initState() {
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
  void dispose() {
    nameController.dispose();
    aboutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 60,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 7,
                      offset: Offset(0, 2),
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
              SizedBox(
                height: 50,
              ),
              Stack(
                children: [
                  Container(
                    child: CircleAvatar(
                      backgroundColor: Colors.black,
                      child: CircleAvatar(
                        radius: 74.0,
                        child: ClipOval(
                          child: _image != null
                              ? Image.file(
                                  _image!,
                                  fit: BoxFit.cover,
                                )
                              : Text(""),
                        ),
                        backgroundColor: Colors.white,
                      ),
                    ),
                    height: 150,
                    width: 150,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: IconButton(
                        onPressed: () {
                          getImage();
                        },
                        icon: Icon(Icons.camera_alt)),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                        width: 290,
                        child: TextFormField(
                          controller: nameController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please Enter Your Name';
                            }

                            return null;
                          },
                          onChanged: (value) {
                            name = value;
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            labelText: "Name",
                          ),
                        )),
                    SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                        width: 290,
                        child: TextField(
                          controller: aboutController,
                          onChanged: (value) {
                            about = value;
                          },
                          maxLines: 5,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.orange),
                              ),
                              labelText: "About",
                              hintText: "Tell about yourself....."),
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
              ),
              SizedBox(
                  width: 130,
                  height: 40,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary: Colors.white,
                        side: BorderSide(
                          width: 1.5,
                          color: Color.fromRGBO(112, 112, 112, 1),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            name = nameController.text;
                            about = aboutController.text;
                          });

                          users.doc(_uid).set({
                            'name': name,
                            'about': about,
                            "url": _url,
                          }).then((value) async {
                            await uploadImage();
                            Navigator.pushReplacementNamed(
                                context, MyRoutes.profilePage);
                          }).catchError(
                              (error) => print("Failed to add user: $error"));
                        }
                      },
                      child: Text(
                        "Create Profile",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 17,
                        ),
                      ))),
            ],
          ),
        ),
      ),
    );
  }
}
