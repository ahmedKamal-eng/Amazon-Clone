import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:sellers_app/brands/upload_brands_screen.dart';
import 'package:sellers_app/global/global.dart';
import 'package:sellers_app/models/brand_model.dart';
import 'package:sellers_app/push_notifications/push_notification_system.dart';

import '../functions/functions.dart';
import '../splashScreen/my_splash_screen.dart';
import '../widgets/my_drawer.dart';
import '../widgets/text_delegate_header_widget.dart';
import 'brands_ui_design_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  getSellerEarningFromDataBase() {
    FirebaseFirestore.instance
        .collection('sellers')
        .doc(sharedPreferences!.getString('uid'))
        .get()
        .then((value) {
      previousEarning = value.data()!['earnings'].toString();
    }).whenComplete((){
      restrictBlockedSellerFromUsingSellersApp();
    });

  }

  restrictBlockedSellerFromUsingSellersApp()async {
    await FirebaseFirestore.instance
        .collection('sellers')
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
  void initState(){
    super.initState();

    PushNotificationsSystem pushNotificationsSystem=PushNotificationsSystem();
   pushNotificationsSystem.whenNotificationReceived(context);
    pushNotificationsSystem.generateDeviceRecognitionToken();
    getSellerEarningFromDataBase();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (c) => UploadBrandsScreen()));
              },
              icon: Icon(
                Icons.add,
                color: Colors.white,
              ))
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: TextDelegateHeaderWidget(title: 'My Brands'),
          ),
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('sellers')
                  .doc(sharedPreferences!.getString('uid'))
                  .collection('brands')
                  .orderBy('publishDate', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot dataSnapshot) {
                if (dataSnapshot.hasData) {
                  return SliverStaggeredGrid.countBuilder(
                    crossAxisCount: 1,
                    staggeredTileBuilder: (c) => const StaggeredTile.fit(1),
                    itemBuilder: (context, index) {
                      Brand brandModel = Brand.fromJson(
                        dataSnapshot.data.docs[index].data()
                            as Map<String, dynamic>,
                      );
                      return BrandsUiDesignWidget(
                        model: brandModel,
                        context: context,
                      );
                    },
                    itemCount: dataSnapshot.data.docs.length,
                  );
                } else {
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: Text('No brands to exists'),
                    ),
                  );
                }
              }),
        ],
      ),
    );
  }
}
