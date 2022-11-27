import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d_chart/d_chart.dart';
import 'package:flutter/material.dart';

import '../widgets/nav_bar.dart';

class UsersPieChartScreen extends StatefulWidget {
  @override
  State<UsersPieChartScreen> createState() => _UsersPieChartScreenState();
}

class _UsersPieChartScreenState extends State<UsersPieChartScreen> {
  int? totalNumberOfVerifiedUsers = 0;
  int? totalNumberOfBlockedUsers = 0;

  getNumberOfAllVerifiedUsers() async {
    FirebaseFirestore.instance
        .collection("users")
        .where("status", isEqualTo: "approved")
        .get()
        .then((allVerifiedSellers) {
      totalNumberOfVerifiedUsers = allVerifiedSellers.docs.length;
      setState(() {});
    }).catchError((e) {
      print('++++++++++++++++++++++++++++++++++++++++++++\n' + e.toString());
    });
  }

  getNumberOfAllBlockedUsers() async {
    FirebaseFirestore.instance
        .collection("users")
        .where("status", isEqualTo: "not approved")
        .get()
        .then((allBlockedSellers) {
      totalNumberOfBlockedUsers = allBlockedSellers.docs.length;
      setState(() {});
    }).catchError((e) {
      print('++++++++++++++++++++++++++++++++++++++++++++\n' + e.toString());
    });
  }

  @override
  void initState() {
    super.initState();
    getNumberOfAllVerifiedUsers();
    getNumberOfAllBlockedUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavAppBar(
        title: 'ishop',
      ),
      body: DChartPie(
        data: [
          {'domain':'Blocked Users', 'measure':totalNumberOfBlockedUsers },
          {'domain':'verified Users', 'measure':totalNumberOfVerifiedUsers},
        ], fillColor: (pieData, index) {
              switch(pieData['domain']){
                case 'Blocked Users':
                  return Colors.pinkAccent;
                case 'verified Users':
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
