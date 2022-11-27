import 'dart:async';

import 'package:admin_web_portal/sellers/verified_sellers_screen.dart';
import 'package:admin_web_portal/users/blocked_users_screen.dart';
import 'package:admin_web_portal/users/verified_users_screen.dart';
import 'package:admin_web_portal/widgets/nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../sellers/blocked_sellers_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String liveTime = '';
  String liveDate = '';

  String formatCurrentTime(DateTime time) {
    return DateFormat('hh:mm:ss a').format(time);
  }

  String formatCurrentDate(DateTime time) {
    return DateFormat('dd MMMM, yyyy').format(time);
  }

  getCurrentLiveDateTime() {
    liveTime = formatCurrentTime(DateTime.now());
    liveDate = formatCurrentDate(DateTime.now());
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    Timer.periodic(const Duration(seconds: 1), (timer) {
      getCurrentLiveDateTime();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: NavAppBar(title: 'ishop',),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                liveTime + '\n' + liveDate,
                style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    letterSpacing: 3,
                    fontWeight: FontWeight.bold),
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (c)=>VerifiedUsersScreen()));
                    },
                    child: Image.asset(
                  'images/verified_users.png',
                  width: 200,
                )),
                const SizedBox(width: 200,),
                GestureDetector(
                    onTap: (){
                     Navigator.push(context, MaterialPageRoute(builder: (c)=>BlockedUsersScreen()));
                    },
                    child: Image.asset(
                      'images/blocked_users.png',
                      width: 200,
                    )),

              ],
            ),

            const SizedBox(height: 20,),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: (){
           Navigator.push(context, MaterialPageRoute(builder: (c)=>VerifiedSellersScreen()));
                    },
                    child: Image.asset(
                      'images/verified_seller.png',
                      width: 200,
                    )),
                const SizedBox(width: 200,),
                GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (c)=>BlockedSellersScreen()));


                    },
                    child: Image.asset(
                      'images/blocked_seller.png',
                      width: 200,
                    )),

              ],
            ),

          ],
        ),
      ),
    );
  }
}
