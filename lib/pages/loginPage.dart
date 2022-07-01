// ignore_for_file: camel_case_types, file_names, prefer_const_constructors, use_build_context_synchronously, unused_local_variable
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meetmefit/utility/routes.dart';

class loginPage extends StatefulWidget {
  const loginPage({Key? key}) : super(key: key);

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isObscure = true;

  String email = "";
  String password = "";

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

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
              SizedBox(height: 40),
              Center(child: Image.asset("assets/logo.png")),
              SizedBox(height: 170),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                        width: 300,
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
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
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            ),
                            labelText: "Email",
                          ),
                        )),
                    SizedBox(height: 30),
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                          obscureText: _isObscure,
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
                          decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
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
                  ],
                ),
              ),
              SizedBox(
                height: 70,
              ),
              SizedBox(
                  width: 110,
                  height: 40,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary: Colors.white,
                        side: BorderSide(
                          width: 1.5,
                          color: Colors.black87,
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            email = emailController.text;
                            password = passwordController.text;
                          });
                          login();
                        }
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 17,
                        ),
                      ))),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 14.5,
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, MyRoutes.signupPage);
                      },
                      child: Text(
                        "Sign up",
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

  Future<void> login() async {
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      await Navigator.pushReplacementNamed(context, MyRoutes.profilePage);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('No user found for that email.'),
        ));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Wrong password provided for that user.'),
        ));
      }
    }
  }
}
