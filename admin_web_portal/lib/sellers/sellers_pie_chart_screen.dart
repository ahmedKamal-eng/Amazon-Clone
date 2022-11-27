import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';

import '../widgets/nav_bar.dart';

class SellersPieChartScreen extends StatefulWidget {
  @override
  State<SellersPieChartScreen> createState() => _SellersPieChartScreenState();
}

class _SellersPieChartScreenState extends State<SellersPieChartScreen> {
  int? totalNumberOfVerifiedSellers = 0;
  int? totalNumberOfBlockedSellers = 0;

  getNumberOfAllVerifiedSellers() async {
    FirebaseFirestore.instance
        .collection("sellers")
        .where("status", isEqualTo: "approved")
        .get()
        .then((allVerifiedSellers) {
      totalNumberOfVerifiedSellers = allVerifiedSellers.docs.length;
      setState(() {});
    }).catchError((e) {
      print('++++++++++++++++++++++++++++++++++++++++++++\n' + e.toString());
    });
  }

  getNumberOfAllBlockedSellers() async {
    FirebaseFirestore.instance
        .collection("sellers")
        .where("status", isEqualTo: "not approved")
        .get()
        .then((allBlockedSellers) {
      totalNumberOfBlockedSellers = allBlockedSellers.docs.length;
      setState(() {});
    }).catchError((e) {
      print('++++++++++++++++++++++++++++++++++++++++++++\n' + e.toString());
    });
  }

  @override
  void initState() {
    super.initState();
    getNumberOfAllVerifiedSellers();
    getNumberOfAllBlockedSellers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavAppBar(
        title: 'ishop',
      ),
      body: DChartPie(
        data: [
          {'domain':'Blocked Sellers', 'measure':totalNumberOfBlockedSellers },
          {'domain':'verified Sellers', 'measure':totalNumberOfVerifiedSellers},
        ], fillColor: (pieData, index) {
              switch(pieData['domain']){
                case 'Blocked Sellers':
                  return Colors.pinkAccent;
                case 'verified Sellers':
                  return Colors.deepPurple;
                default:
                  return Colors.grey;
              }
          },
        animate: false,
        labelFontSize: 20,
        pieLabel: (pieData,index){
          return '${pieData['domain']}';
        },
        labelColor: Colors.white,
        strokeWidth: 6,

      ),

    );
  }
}
