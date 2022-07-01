import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'pages/createProfilePade.dart';
import 'pages/loginPage.dart';
import 'pages/profilePage.dart';
import 'pages/signupPage.dart';
import 'utility/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: const loginPage(),
      routes: {
        MyRoutes.loginPage: (context) => const loginPage(),
        MyRoutes.signupPage: (context) => const signupPage(),
        MyRoutes.createProfilePage: (context) => createProfilePage(),
        MyRoutes.profilePage: (context) => profilePage(),
      },
    );
  }
}
