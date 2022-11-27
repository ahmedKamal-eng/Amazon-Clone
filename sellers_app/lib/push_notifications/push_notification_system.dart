import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:sellers_app/functions/functions.dart';
import 'package:sellers_app/global/global.dart';

class PushNotificationsSystem {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // notifications arrived
  Future whenNotificationReceived(BuildContext context) async {
    //1.terminated
    //when the app closed and opened from notification
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        showNotificationWhenOpenApp(
            remoteMessage.data['userOrderId'], context);
      }
    });

    //2.foreground
    //when app is open and receive a notification
    FirebaseMessaging.onMessage.listen((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {

        showNotificationWhenOpenApp(
            remoteMessage.data['userOrderId'], context);
      }
    });

    //3. Background
    //the app is in the background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        showNotificationWhenOpenApp(
            remoteMessage.data['userOrderId'], context);
      }
    });
  }

  //device recognition token
  Future generateDeviceRecognitionToken() async {
    String? registrationDeviceToken = await messaging.getToken();

    FirebaseFirestore.instance
        .collection('sellers')
        .doc(sharedPreferences!.getString('uid'))
        .update({'sellerDeviceToken': registrationDeviceToken});

    messaging.subscribeToTopic('allSellers');
    messaging.subscribeToTopic('allUsers');
  }

  showNotificationWhenOpenApp(orderId, context) async {
    await FirebaseFirestore.instance
        .collection('orders')
        .doc(orderId)
        .get()
        .then((snapshot) {
          if(snapshot.data()!['status']=='ended'){
             showReuseableSnack('Order Id #$orderId \n\n has delivered by the user', context);
          }
          else
            {
              showReuseableSnack('You have new Order. \n Order Id # $orderId \n\n Please Check now.', context);
            }
    });
  }
}
