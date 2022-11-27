
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:users_app/global/global.dart';
import 'package:users_app/historyScreen/history_screen.dart';
import 'package:users_app/notYetReceivedParcels/not_yet_received_parcel_screen.dart';
import 'package:users_app/ordersScreen/orders_screen.dart';
import 'package:users_app/searchScreen/search_screen.dart';
import 'package:users_app/splashScreen/my_splash_screen.dart';

import '../sellersScreen/home_screen.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.black54,
      child: ListView(
        children: [
         //header
          Container(
            padding: EdgeInsets.only(top: 20,bottom: 12),
            child: Column(
              children: [
                Container(
                  height: 130,
                  width: 130,
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(sharedPreferences!.getString('photoUrl')!),

                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(sharedPreferences!.getString('name')!,
                 style: TextStyle(
                   fontSize: 20,
                   color: Colors.grey,
                   fontWeight: FontWeight.bold
                 ),
                ),
              ],
            ),
          ),
          const Divider(
            height: 10,
            thickness: 2,
            color: Colors.grey,
          ),

          //body
          Container(
            padding: EdgeInsets.only(top: 10),
            child: Column(
              children: [
                //home
                ListTile(
                  leading: Icon(Icons.home,color: Colors.grey,),
                  title: Text('home',
                   style: TextStyle(color: Colors.grey),
                  ),
                  onTap: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=>HomeScreen()));


                  },
                ),
                const Divider(
                  height: 10,
                  thickness: 2,
                  color: Colors.grey,
                ),
                //order
                ListTile(
                  leading: Icon(Icons.reorder,color: Colors.grey,),
                  title: Text('My orders',
                    style: TextStyle(color: Colors.grey),
                  ),
                  onTap: ()
                  {
                  Navigator.push(context, MaterialPageRoute(builder: (c)=>OrdersScreen()));
                  },
                ),
                const Divider(
                  height: 10,
                  thickness: 2,
                  color: Colors.grey,
                ),
                //not yet received
                ListTile(
                  leading: Icon(Icons.picture_in_picture_alt_rounded,color: Colors.grey,),
                  title: Text('not yet received',
                    style: TextStyle(color: Colors.grey),
                  ),
                  onTap: ()
                  {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=>NotYetReceivedParcelsScreen()));
                  },
                ),
                const Divider(
                  height: 10,
                  thickness: 2,
                  color: Colors.grey,
                ),

                //history
                ListTile(
                  leading: Icon(Icons.history,color: Colors.grey,),
                  title: Text('history',
                    style: TextStyle(color: Colors.grey),
                  ),
                  onTap: ()
                  {
      Navigator.push(context, MaterialPageRoute(builder: (c)=>HistoryScreen()));
                  },
                ),
                const Divider(
                  height: 10,
                  thickness: 2,
                  color: Colors.grey,
                ),

                //search
                ListTile(
                  leading: Icon(Icons.search,color: Colors.grey,),
                  title: Text('searh',
                    style: TextStyle(color: Colors.grey),
                  ),
                  onTap: ()
                  {
                 Navigator.push(context, MaterialPageRoute(builder: (c)=>SearchScreen()));},
                ),
                const Divider(
                  height: 10,
                  thickness: 2,
                  color: Colors.grey,
                ),

                //logout
                ListTile(
                  leading: Icon(Icons.logout,color: Colors.grey,),
                  title: Text('logout',
                    style: TextStyle(color: Colors.grey),
                  ),
                  onTap: ()
                  {
                    FirebaseAuth.instance.signOut();
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>MySplashScreen()));
                    
                  },
                ),
                const Divider(
                  height: 10,
                  thickness: 2,
                  color: Colors.grey,
                ),
              ],
            ),
          )

        ],
      ),
    );
  }
}
