import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:users_app/functions/functions.dart';
import 'package:users_app/global/global.dart';
import 'package:users_app/push_notifications/push_notification_system.dart';
import 'package:users_app/sellersScreen/sellers_ui_design_widget.dart';
import 'package:users_app/splashScreen/my_splash_screen.dart';
import 'package:users_app/widgets/my_drawer.dart';

import '../models/seller_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  restrictBlockedUsersFromUsingUsersApp()async {
     await FirebaseFirestore.instance
        .collection('users')
        .doc(sharedPreferences!.getString('uid'))
        .get()
        .then((snapshot) {
           if(snapshot.data()!['status'] != 'approved')
             {
               showReuseableSnack('You Are Blocked By Admin', context);
               showReuseableSnack('contact Admin ', context);

               FirebaseAuth.instance.signOut();
               Navigator.push(context, MaterialPageRoute(builder: (c)=>MySplashScreen()));
             }
         });
  }

  @override
  initState() {
    super.initState();
    PushNotificationsSystem pushNotificationsSystem = PushNotificationsSystem();
    pushNotificationsSystem.generateDeviceRecognitionToken();
    pushNotificationsSystem.whenNotificationReceived(context);

    restrictBlockedUsersFromUsingUsersApp();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      drawer: MyDrawer(),
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
        title: Text(
          'IShop',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width,
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: MediaQuery.of(context).size.width * 0.9,
                    aspectRatio: 16 / 9,
                    viewportFraction: 0.8,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: const Duration(seconds: 3),
                    autoPlayAnimationDuration:
                        const Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal,
                  ),
                  items: itemsImageList.map((e) {
                    return Builder(builder: (c) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: const EdgeInsets.symmetric(horizontal: 1.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: Image.asset(
                            e,
                            fit: BoxFit.fill,
                          ),
                        ),
                      );
                    });
                  }).toList(),
                ),
              ),
            ),
          ),
          StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('sellers').snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return SliverStaggeredGrid.countBuilder(
                    crossAxisCount: 1,
                    staggeredTileBuilder: (c) => const StaggeredTile.fit(1),
                    itemBuilder: (context, index) {
                      Seller model = Seller.fromJson(snapshot.data.docs[index]
                          .data() as Map<String, dynamic>);
                      return SellersUiDesignWidget(
                        model: model,
                      );
                    },
                    itemCount: snapshot.data.docs.length,
                  );
                } else {
                  return SliverToBoxAdapter(
                    child: Center(
                      child: Text('no Sellers to Show'),
                    ),
                  );
                }
              }),
        ],
      ),
    );
  }
}
