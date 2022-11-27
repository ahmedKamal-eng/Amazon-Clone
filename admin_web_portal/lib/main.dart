import 'package:admin_web_portal/authentication/login_screen.dart';
import 'package:admin_web_portal/homeScreen/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: "AIzaSyDaDal7glp0hbpzJGoNGJwmTNyjtxeBGEE",
          appId: "1:757455724597:web:eb3e01113fe55153f0517c",
          messagingSenderId:"clone-67f46.appspot.com",
          projectId: "clone-67f46"),);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Admin web portal',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: FirebaseAuth.instance.currentUser == null
          ? LoginScreen()
          : HomeScreen(),
    );
  }
}
