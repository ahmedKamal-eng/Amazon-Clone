import 'package:flutter/material.dart';
import 'package:sellers_app/authScreens/registration_tap_page.dart';

import 'login_tap_page.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {



  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            //make a gradient color
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.pinkAccent, Colors.purpleAccent],
                  begin: FractionalOffset(0.0, 0.0),
                  end: FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
          ),
          title: const Text(
            'iShop',
            style: TextStyle(fontSize: 28),
          ),
          centerTitle: true,
          bottom: const TabBar(
              indicatorColor: Colors.white,
              indicatorWeight: 8,
              tabs: [
                Tab(
                  text: 'login',
                  icon: Icon(
                    Icons.lock,
                    color: Colors.white,
                  ),
                ),
                Tab(
                  text: 'register',
                  icon: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                ),
              ]),
        ),
        body: Container(
          //make a gradient color
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.pinkAccent, Colors.purpleAccent],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
          child: TabBarView(
            children: [
              LoginTapPage(),
              RegistrationTapPage()
            ],
          ),
        ),
      ),
    );
  }
}
