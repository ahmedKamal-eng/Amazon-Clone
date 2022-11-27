import 'package:shared_preferences/shared_preferences.dart';
import '../assistantMethods/cart_methods.dart';

SharedPreferences? sharedPreferences;

final itemsImageList=[
   'slider/0.jpg',
   'slider/1.jpg',
   'slider/2.jpg',
   'slider/3.jpg',
   'slider/4.jpg',
   'slider/5.jpg',
   'slider/6.jpg',
   'slider/7.jpg',
   'slider/8.jpg',
   'slider/9.jpg',
   'slider/10.jpg',
   'slider/11.jpg',
   'slider/12.jpg',
   'slider/13.jpg'
];

CartMethods cartMethods=CartMethods();

double countStarRating=0.0;
String titleStarsRating='';
String fcmServerToken='key=AAAAsFvhIDU:APA91bF7Yorv2YaPpuZKFs9cj6Xx20Bu44MgyVG2ZhGbCxP4NcMCPPBS2G102nadllgDCpDaN1HU_8dmBXhiKVHW29RVKBr6-Fd-4OQGnbREu3laOw_V_8jYhrB126JEvQgr7QV0NjLh';


