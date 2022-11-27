import 'package:admin_web_portal/functions/functions.dart';
import 'package:admin_web_portal/homeScreen/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = '';
  String password = '';

  allowAdminToLogin() async {
    if (email == '' || password == '') {
      showReuseableSnack('please provide email && password', context);
    } else {
      User? currentAdmin;
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        currentAdmin = value.user;
      }).catchError((e) {
        showReuseableSnack('Error Occured: $e', context);
      });

      await FirebaseFirestore.instance
          .collection('admins')
          .doc(currentAdmin!.uid)
          .get()
          .then((snapshot) {

            if(snapshot.exists)
              {
                Navigator.push(context, MaterialPageRoute(builder: (c)=>HomeScreen()));
              }
            else
              {
                showReuseableSnack('No record found, you are not an admin', context);
              }

           });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('images/admin.png'),
                  TextField(
                    onChanged: (value) {
                      email = value;
                    },
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.purpleAccent, width: 2)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white54, width: 2),
                      ),
                      hintText: 'Email',
                      hintStyle: TextStyle(color: Colors.grey),
                      icon: Icon(
                        Icons.email,
                        color: Colors.deepPurpleAccent,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    onChanged: (value) {
                      password = value;
                    },
                    obscureText: true,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.purpleAccent, width: 2)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white54, width: 2),
                      ),
                      hintText: 'Password',
                      hintStyle: TextStyle(color: Colors.grey),
                      icon: Icon(
                        Icons.password,
                        color: Colors.deepPurpleAccent,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        showReuseableSnack(
                            'Checking Credentials, please wait', context);

                        allowAdminToLogin();
                      },
                      style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 100, vertical: 20),
                          primary: Colors.deepPurpleAccent),
                      child: Text(
                        'login',
                        style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 2,
                            fontSize: 16),
                      ))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
