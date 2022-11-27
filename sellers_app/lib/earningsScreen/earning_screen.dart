import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sellers_app/brands/home_screen.dart';
import 'package:sellers_app/global/global.dart';

class EarningsScreen extends StatefulWidget {
  @override
  State<EarningsScreen> createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {
  String totalSellerEarning = '';

  readTotalEarnings() {
    FirebaseFirestore.instance
        .collection('sellers')
        .doc(sharedPreferences!.getString('uid'))
        .get()
        .then((value) {
      setState(() {
        totalSellerEarning = value.data()!['earnings'].toString();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    readTotalEarnings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'E£ ' + totalSellerEarning,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'total earnings',
                style: TextStyle(
                    color: Colors.white38, letterSpacing: 3, fontSize: 18),
              ),
              const SizedBox(
                height: 10,
              ),
               const SizedBox(
                  width: 200,
                  child: Divider(height: 10,thickness: 2,color: Colors.white,)),
               const SizedBox(height: 20,),
              Card(
                margin: EdgeInsets.symmetric(horizontal: 70,vertical: 50),
                color: Colors.white38,
                child: ListTile(
                  leading: Icon(Icons.arrow_back,color: Colors.white,),
                  title: Text('go Back',style: TextStyle(color: Colors.white),),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (c)=>HomeScreen()));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
