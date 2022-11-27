import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:users_app/global/global.dart';
import 'package:users_app/models/address.dart';
import 'package:users_app/ordersScreen/order_status_banner.dart';
import 'package:users_app/widgets/address_design_widget.dart';

class OrderDetailsScreen extends StatefulWidget {
  String? orderId;

  OrderDetailsScreen({this.orderId});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  String? orderStatus;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('users')
            .doc(sharedPreferences!.getString('uid'))
            .collection('orders')
            .doc(widget.orderId)
            .get(),
        builder: (context, AsyncSnapshot snapshot) {
          Map? orderDataMap;
          if (snapshot.hasData) {
            orderDataMap = snapshot.data.data() as Map<String, dynamic>;
            orderStatus = orderDataMap['status'].toString();
            return SingleChildScrollView(
              child: Column(
                children: [
                  StatusBanner(
                    status: orderDataMap['isSuccess'],
                    orderStatus: orderStatus,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "E£" + orderDataMap['totalAmount'].toString(),
                        style: const TextStyle(
                          color: Colors.blueGrey,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "order ID: " + orderDataMap['orderId'].toString(),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "order at: " +
                            DateFormat('dd MMM, yyyy - hh:mm aa').format(
                                DateTime.fromMicrosecondsSinceEpoch(
                                    int.parse(orderDataMap['orderTime']))),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),

                  const Divider(
                    thickness: 4,
                    color: Colors.pink,
                  ),
                  orderStatus == 'ended'
                      ? Image.asset('images/delivered.png')
                      : Image.asset('images/state.png'),
                  const Divider(
                    thickness: 4,
                    color: Colors.pink,
                  ),
                  FutureBuilder(
                    future: FirebaseFirestore.instance
                        .collection('users')
                        .doc(sharedPreferences!.getString('uid'))
                        .collection('userAddress')
                        .doc(orderDataMap['addressID'])
                        .get(),
                    builder: (c, AsyncSnapshot dataSnapshot) {
                        if(dataSnapshot.hasData)
                          {
                            return AddressDesign(
                              model: Address.fromJson(dataSnapshot.data.data() as Map<String,dynamic>),
                              orderStatus: orderStatus,
                              orderId: widget.orderId,
                              sellerId: orderDataMap!['sellerUID'],
                              orderByUser: orderDataMap['orderBy'],

                            );
                          }
                        else
                          {
                            return const Center(child: Text('no data exist'),);
                          }
                    },
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('there is no data'));
          }
        },
      ),
    );
  }
}
