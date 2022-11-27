import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:users_app/authScreens/auth_screen.dart';


import '../sellersScreen/home_screen.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {

  splashScreenTimer(){
    Timer(const Duration(seconds: 2),()async{
      if(FirebaseAuth.instance.currentUser !=null)
        {
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return HomeScreen();
          }));

        }else{
        Navigator.push(context, MaterialPageRoute(builder: (context){
          return AuthScreen();
        }));
      }

    });
  }

  @override
  void initState(){
    super.initState();
    splashScreenTimer();
  }
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        //make a gradient color
        decoration:const BoxDecoration(
          gradient: LinearGradient(
              colors: [
                Colors.pinkAccent,
                Colors.purpleAccent
              ],
              begin: FractionalOffset(0.0 ,0.0),
              end: FractionalOffset(1.0,0.0),
              stops: [0.0,1.0],
              tileMode: TileMode.clamp
          ),
        ),
         child: Center(
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Image.asset('images/welcome.png'),
              const SizedBox(height: 15,),
               const Text('iShop Users App',
               style: TextStyle(
                 fontSize: 30,
                 color: Colors.white,
                 fontWeight: FontWeight.bold,
                 letterSpacing: 3
               ),
               ),
             ],
           ),
         ),
      ),
    );
  }
}
