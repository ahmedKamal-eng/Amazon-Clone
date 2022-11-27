import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:users_app/functions/functions.dart';

import '../global/global.dart';


class PushNotificationsSystem {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // notifications arrived
  Future whenNotificationReceived(BuildContext context) async
  {
    //1.terminated
    //when the app closed and opened from notification
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? remoteMessage){
        if(remoteMessage != null)
          {
            showNotificationWhenOpenApp(
              remoteMessage.data['userOrderId'],
              context
            );

          }
    });

    //2.foreground
    //when app is open and receive a notification
     FirebaseMessaging.onMessage.listen((RemoteMessage? remoteMessage) {
       if(remoteMessage != null)
         {

           showNotificationWhenOpenApp(
               remoteMessage.data['userOrderId'],
               context
           );


         }
     });

    //3. Background
   //the app is in the background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? remoteMessage) {
      if(remoteMessage != null)
        {

          showNotificationWhenOpenApp(
              remoteMessage.data['userOrderId'],
              context
          );


        }
    });



  }


  //device recognition token
  Future generateDeviceRecognitionToken() async {
    String? registrationDeviceToken = await messaging.getToken();

    FirebaseFirestore.instance
        .collection('users')
        .doc(sharedPreferences!.getString('uid'))
        .update({'usersDeviceToken': registrationDeviceToken});

    messaging.subscribeToTopic('allSellers');
    messaging.subscribeToTopic('allUsers');

  }


  showNotificationWhenOpenApp(userOrderId,context){
    showReuseableSnack('Your Parcel (#$userOrderId) shifted successfully', context);
  }

}
