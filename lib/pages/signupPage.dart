// ignore_for_file: camel_case_types, file_names, unused_element, use_build_context_synchronously, unused_local_variable, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../utility/routes.dart';

class signupPage extends StatefulWidget {
  const signupPage({Key? key}) : super(key: key);

  @override
  State<signupPage> createState() => _signupPageState();
}

class _signupPageState extends State<signupPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;

  String email = "";
  String password = "";
  String confirmPassword = "";

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              Center(child: Image.asset("assets/logo.png")),
              const SizedBox(height: 80),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                        width: 300,
                        child: TextFormField(
                          controller: emailController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please Enter Your Email';
                            }
                            if (!RegExp(
                                    "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                .hasMatch(value)) {
                              return 'Please a valid Email';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            email = value;
                          },
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            labelText: "Email",
                          ),
                        )),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                          controller: passwordController,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please Enter Password';
                            }

                            return null;
                          },
                          onChanged: (value) {
                            password = value;
                          },
                          obscureText: _isObscure,
                          decoration: InputDecoration(
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            labelText: 'Password',
                            suffixIcon: IconButton(
                                icon: Icon(_isObscure
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _isObscure = !_isObscure;
                                  });
                                }),
                          )),
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                          controller: confirmPasswordController,
                          obscureText: _isObscure,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please Enter Conifrm Password';
                            }
                            if (value != password) {
                              return "Confirm password must be same";
                            }
                            return null;
                          },
                          onChanged: (value) {
                            confirmPassword = value;
                          },
                          decoration: InputDecoration(
                            enabledBorder: const UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            labelText: 'Confirm Password',
                            suffixIcon: IconButton(
                                icon: Icon(_isObscure
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _isObscure = !_isObscure;
                                  });
                                }),
                          )),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 70),
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
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            email = emailController.text;
                            password = passwordController.text;
                            confirmPassword = confirmPasswordController.text;
                          });

                          signup();
                        }
                      },
                      child: const Text(
                        "Signup",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 17,
                        ),
                      ))),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account?",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14.5,
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, MyRoutes.loginPage);
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 15,
                        ),
                      ))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signup() async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await Navigator.pushReplacementNamed(context, MyRoutes.createProfilePage);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('The password provided is too weak.'),
        ));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('The account already exists for that email.'),
        ));
      }
    } catch (e) {
      print(e);
    }
  }
}
