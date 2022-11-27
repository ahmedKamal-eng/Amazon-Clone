import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';
import 'package:users_app/global/global.dart';
import 'package:users_app/splashScreen/my_splash_screen.dart';

class RateSellerScreen extends StatefulWidget {
  String? id;
  RateSellerScreen({this.id});

  @override
  State<RateSellerScreen> createState() => _RateSellerScreenState();
}

class _RateSellerScreenState extends State<RateSellerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Dialog(
        backgroundColor: Colors.white60,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          margin: const EdgeInsets.all(8),
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.white54, borderRadius: BorderRadius.circular(16)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                height: 22,
              ),
              const Text(
                'Rate the seller',
                style: TextStyle(
                    fontSize: 22,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 22,
              ),
             const Divider(
                height: 4,
                thickness: 4,
              ),
              const SizedBox(
                height: 22,
              ),
              SmoothStarRating(
                  rating: countStarRating,
                  allowHalfRating: true,
                  starCount: 5,
                  color: Colors.purpleAccent,
                  borderColor: Colors.purpleAccent,
                  size: 46,
                  onRatingChanged: (value) {
                    countStarRating = value;

                    if (countStarRating == 1) {
                      setState(() {
                        titleStarsRating = 'very bad';
                      });
                    } else if (countStarRating == 2) {
                      setState(() {
                        titleStarsRating = 'bad';
                      });
                    }
                    else if (countStarRating == 3) {
                      setState(() {
                        titleStarsRating = 'good';
                      });
                    }
                    else if (countStarRating == 4) {
                      setState(() {
                        titleStarsRating = 'very good';
                      });
                    }
                    else if (countStarRating == 5) {
                      setState(() {
                        titleStarsRating = 'excellent';
                      });
                    }
                  }),
            const   SizedBox(
                height: 22,
              ),
              Text(titleStarsRating,style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.purpleAccent
              ),),
              const SizedBox(height: 22,),
              ElevatedButton(onPressed: (){
               FirebaseFirestore.instance.collection('sellers').doc(widget.id).get().then((snap){
                   if(snap.data()!['ratings'] == null)
                     {
                       FirebaseFirestore.instance.collection('sellers').doc(widget.id).update({
                         'ratings':countStarRating.toString()
                       });
                     }
                   else{
                       double pastRating=double.parse(snap.data()!['ratings'].toString());
                       double currentRating=(pastRating+countStarRating) / 2;

                     FirebaseFirestore.instance.collection('sellers').doc(widget.id).update(
                         {
                           'ratings':currentRating.toString()
                         });

                   }
                   setState((){
                     countStarRating=0.0;
                     titleStarsRating='';
                   });
                   Fluttertoast.showToast(msg: 'rated successfully',backgroundColor: Colors.tealAccent,textColor: Colors.black);
                   Navigator.push(context,MaterialPageRoute(builder: (c)=>MySplashScreen()));
               });
              },
                child: const Text('submit'),
                style: ElevatedButton.styleFrom(
                   primary: Colors.purpleAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 74)
               ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
