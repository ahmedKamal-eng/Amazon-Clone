
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../global/global.dart';
import '../ordersScreen/order_card.dart';


class ShiftedParcelsScreen extends StatefulWidget {
  const ShiftedParcelsScreen({Key? key}) : super(key: key);

  @override
  State<ShiftedParcelsScreen> createState() => _ShiftedParcelsScreenState();
}

class _ShiftedParcelsScreenState extends State<ShiftedParcelsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
          'Shifted Parcels',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('orders')
            .where('status', isEqualTo: 'shifted')
            .where('sellerUID', isEqualTo: sharedPreferences!.getString('uid'))
            .orderBy('orderTime', descending: true)
            .snapshots(),
        builder: (context, AsyncSnapshot dataSnapshot) {
          if (dataSnapshot.hasData) {
            return ListView.builder(
              itemCount: dataSnapshot.data.docs.length,
              itemBuilder: (context, index) {
                return FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('items')
                      .where('itemId',
                      whereIn: cartMethods.separateOrdersItemIds(
                          (dataSnapshot.data.docs[index].data()
                          as Map<String, dynamic>)['productIds']))
                      .where('sellerUID',
                      whereIn: (dataSnapshot.data.docs[index].data()
                      as Map<String, dynamic>)['uid'])
                      .orderBy('publishDate', descending: true)
                      .get(),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return OrderCard(
                        intCount: snapshot.data.docs.length,
                        data: snapshot.data.docs,
                        orderId: dataSnapshot.data.docs[index].id,
                        seperateQuantitiesList:
                        cartMethods.separateOrderItemQuantities(
                            (dataSnapshot.data.docs[index].data()
                            as Map<String, dynamic>)['productIds']),
                      );
                    } else {
                      return const Center(
                        child: Text('there is no data'),
                      );
                    }
                  },
                );
              },
            );
          } else {
            return const Center(
              child: Text('there is no data'),
            );
          }
        },
      ),
    );
  }
}
