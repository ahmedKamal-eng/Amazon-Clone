import 'package:admin_web_portal/functions/functions.dart';
import 'package:admin_web_portal/homeScreen/home_screen.dart';
import 'package:admin_web_portal/widgets/nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VerifiedSellersScreen extends StatefulWidget {
  @override
  State<VerifiedSellersScreen> createState() => _VerifiedSellersScreenState();
}

class _VerifiedSellersScreenState extends State<VerifiedSellersScreen> {
  QuerySnapshot? allApprovedSellers;

  getAllVerifiedSellers() async {
    FirebaseFirestore.instance
        .collection("sellers")
        .where("status", isEqualTo: "approved")
        .get()
        .then((allVerifiedSellers) {
      allApprovedSellers = allVerifiedSellers;
      setState(() {});
    }).catchError((e) {
      print('++++++++++++++++++++++++++++++++++++++++++++\n' + e.toString());
    });
  }

  showDialogBox(userDocumentId) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Block Account'),
            content: const Text(
              'Do you want to block this account',
              style: TextStyle(fontSize: 16, letterSpacing: 2),
            ),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('no')),
              ElevatedButton(
                  onPressed: () async {
                    await FirebaseFirestore.instance
                        .collection('sellers')
                        .doc(userDocumentId)
                        .update({'status': 'not approved'}).whenComplete(() {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (c) => HomeScreen()));
                      showReuseableSnack('Blocked successfully', context);
                    });
                  },
                  child: Text('yes')),
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    getAllVerifiedSellers();
  }

  @override
  Widget build(BuildContext context) {
    Widget verifiedSellersDesign() {
      if (allApprovedSellers == null) {
        return Center(
          child: Text(
            'No Record found.',
            style: TextStyle(
              fontSize: 30,
            ),
          ),
        );
      } else {
        return ListView.builder(
          padding: EdgeInsets.all(10),
          itemBuilder: (context, index) {
            return Card(
              elevation: 10,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 180,
                      height: 140,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(
                                allApprovedSellers!.docs[index]['photoUrl']),
                          )),
                    ),
                  ),
                  Text(
                    allApprovedSellers!.docs[index]['name'],
                  ),
                  Text(
                    allApprovedSellers!.docs[index]['email'],
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      GestureDetector(
                        onTap: () {
                          showDialogBox(allApprovedSellers!.docs[index]['uid']);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16, bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'images/block.png',
                                width: 60,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              const Text(
                                'Block Now',
                                style: TextStyle(color: Colors.redAccent),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showReuseableSnack(
                              'Total Earning:' +
                                  allApprovedSellers!.docs[index]
                                      .get('earnings')
                                      .toString() +'E£',
                              context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 16, bottom: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'images/earnings.png',
                                width: 60,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Text(
                                'E£' +
                                    allApprovedSellers!.docs[index]
                                        .get('earnings')
                                        .toString(),
                                style: const TextStyle(color: Colors.redAccent),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
          itemCount: allApprovedSellers!.docs.length,
        );
      }
    }

    return Scaffold(
      appBar: NavAppBar(
        title: 'Verified Sellers Accounts',
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * .5,
          child: verifiedSellersDesign(),
        ),
      ),
    );
  }
}
