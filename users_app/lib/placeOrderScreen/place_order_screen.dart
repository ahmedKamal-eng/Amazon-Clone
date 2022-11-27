import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:users_app/global/global.dart';
import 'package:users_app/sellersScreen/home_screen.dart';
import 'package:http/http.dart' as http;
class PlaceOrderScreen extends StatefulWidget {
  String? addressID;
  double? totalAmount;
  String? sellerUID;

  PlaceOrderScreen({this.addressID, this.totalAmount, this.sellerUID});

  @override
  State<PlaceOrderScreen> createState() => _PlaceOrderScreenState();
}

class _PlaceOrderScreenState extends State<PlaceOrderScreen> {
  String orderID = DateTime.now().millisecondsSinceEpoch.toString();

  orderDetails() {


    saveOrderDetailsForUser({

      'addressID':widget.addressID,
      "totalAmount":widget.totalAmount,
      'orderBy':sharedPreferences!.getString('uid'),
      'productIds':sharedPreferences!.getStringList('userCart'),
      'paymentDetails':'cash on delivery',
      'orderTime':orderID,
      'orderId':orderID,
      'isSuccess':true,
      'sellerUID':widget.sellerUID,
      'status':'normal',

    }).whenComplete(( ){
        saveOrderDetailsForSeller({

          'addressID':widget.addressID,
          "totalAmount":widget.totalAmount,
          'orderBy':sharedPreferences!.getString('uid'),
          'productIds':sharedPreferences!.getStringList('userCart'),
          'paymentDetails':'cash on delivery',
          'orderTime':orderID,
          'orderId':orderID,
          'isSuccess':true,
          'sellerUID':widget.sellerUID,

          'status':'normal',

        }).whenComplete((){
           cartMethods.clearCart(context);

           // notification
           sendNotificationToSeller(
             widget.sellerUID.toString(),
             orderID
           );

          Fluttertoast.showToast(msg: 'Order has been placed successfully');
          orderID='';
          Navigator.push(context, MaterialPageRoute(builder: (c)=>HomeScreen()));
        });
    });



  }

  saveOrderDetailsForUser(Map<String, dynamic> orderDetailsMap) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(sharedPreferences!.getString('uid'))
        .collection('orders')
        .doc(orderID)
        .set(orderDetailsMap);
  }

  saveOrderDetailsForSeller(Map<String, dynamic> orderDetailsMap) async {
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(orderID)
        .set(orderDetailsMap);
  }

  sendNotificationToSeller(sellerUID ,orderID)async{
      String? sellerDeviceToken="";
     await  FirebaseFirestore.instance.collection('sellers').doc(sellerUID).get().then((snapshot) {
          sellerDeviceToken=snapshot.data()!['sellerDeviceToken'].toString();
          print('Device Token++++++++++++====================='+sellerDeviceToken!);
          print('Device Token++++++++++++====================='+orderID);
      });

      notificationFormat(
        sellerDeviceToken,
        orderID,
        sharedPreferences!.getString('name')
      );
  }

  notificationFormat(sellerDeviceToken,orderID,userName){

    Map<String, String> headerNotification={
      'content-Type':'application/json',
      'Authorization':fcmServerToken
    };

    Map bodyNotification={
      'body':'Dear seller, (# $orderID) has placed Successfully from user $userName \n please check now',
      'title':'New Order'
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
      'to':sellerDeviceToken
    };
    
    http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: headerNotification,
      body: jsonEncode(officialNotificationFormat)
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('images/delivery.png'),
            const SizedBox(
              height: 12,
            ),
            ElevatedButton(
                onPressed: () {
                  orderDetails();
                },
                style: ElevatedButton.styleFrom(primary: Colors.green),
                child: const Text('please order now')),
          ],
        ),
      ),
    );
  }
}
