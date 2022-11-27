import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sellers_app/global/global.dart';

import '../models/address.dart';
import '../splashScreen/my_splash_screen.dart';
import 'package:http/http.dart' as http;

class AddressDesign extends StatelessWidget {
  Address? model;
  String? orderStatus;
  String? orderId;
  String? sellerId;
  String? orderByUser;
  String? totalAmount;

  AddressDesign(
      {this.model,
      this.orderStatus,
      this.orderId,
      this.sellerId,
      this.orderByUser,
      this.totalAmount});


  sendNotificationToUser(userUID ,orderID) async{
    String? userDeviceToken="";
   await FirebaseFirestore.instance.collection('users').doc(userUID).get().then((snapshot) {

      if(snapshot.data()!["usersDeviceToken"] != null){
        userDeviceToken=snapshot.data()!['usersDeviceToken'].toString();
        print('Device Token++++++++++++====================='+userDeviceToken!);
        print('Device Token++++++++++++====================='+orderID);}
    });

    notificationFormat(
        userDeviceToken,
        orderID,
        sharedPreferences!.getString('name')
    );
  }

  notificationFormat(userDeviceToken,orderID,sellerName){

    print('device token'+userDeviceToken);
    print('divice '+orderID);

    Map<String, String> headerNotification={
      'content-Type':'application/json',
      'Authorization':fcmServerToken
    };

    Map bodyNotification={
      'body':'Dear user, your parcel (# $orderID) has shifted Successfully by seller $sellerName \n please check now',
      'title':'parcel shifted',
    };

    Map dataMap=
    {
      'click-action':'FLUTTER-NOTIFICATION-CLICK',
      'id':'1',
      'status':'done',
      'userOrderId':orderID
    };

    Map officialNotificationFormat={
      'notification':bodyNotification,
      'data':dataMap,
      'priority':'high',
      'to':userDeviceToken
    };

    http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: headerNotification,
        body: jsonEncode(officialNotificationFormat)
    );

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            'Shipping Details',
            style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 5),
          width: MediaQuery.of(context).size.width,
          child: Table(
            children: [
              TableRow(
                children: [
                  const Text(
                    'Name',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    model!.name.toString(),
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  )
                ],
              ),
              const TableRow(
                children: [
                  SizedBox(
                    height: 3,
                  ),
                  SizedBox(
                    height: 3,
                  )
                ],
              ),
              TableRow(
                children: [
                  const Text(
                    'Phone Number',
                    style: TextStyle(color: Colors.grey),
                  ),
                  Text(
                    model!.phoneNumber.toString(),
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            model!.completeAddress.toString(),
            style: const TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            if (orderStatus == 'normal') {
              FirebaseFirestore.instance
                  .collection('sellers')
                  .doc(sharedPreferences!.getString('uid'))
                  .update({
                'earnings': (double.parse(previousEarning)) +
                    (double.parse(totalAmount!))
              }).whenComplete(() {
                FirebaseFirestore.instance
                    .collection('orders')
                    .doc(orderId)
                    .update({'status': 'shifted'}).whenComplete(() {
                  FirebaseFirestore.instance
                      .collection('users')
                      .doc(orderByUser)
                      .collection('orders')
                      .doc(orderId)
                      .update({'status': 'shifted'});
                }).whenComplete((){
                  // send notification

                  sendNotificationToUser(orderByUser, orderId);

                  Fluttertoast.showToast(msg: 'confirmed Successfully',backgroundColor: Colors.tealAccent,textColor: Colors.black);
                  Navigator.push(context, MaterialPageRoute(builder: (c)=>MySplashScreen()));
                });
              });
            } else if (orderStatus == 'shifted') {
            } else if (orderStatus == 'ended') {
            } else {
              Navigator.push(
                  context, MaterialPageRoute(builder: (c) => MySplashScreen()));
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.pinkAccent, Colors.purpleAccent],
                    begin: FractionalOffset(0.0, 0.0),
                    end: FractionalOffset(1.0, 0.0),
                    stops: [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
              width: MediaQuery.of(context).size.width - 40,
              height: orderStatus == 'ended'
                  ? 60
                  : MediaQuery.of(context).size.height * .07,
              child: Center(
                child: Text(
                  orderStatus == 'ended'
                      ? 'Do you want to rate this seller'
                      : orderStatus == 'shifted'
                          ? 'Go back'
                          : orderStatus == 'normal'
                              ? 'parcel delivered & received \n click to confirm'
                              : '',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
