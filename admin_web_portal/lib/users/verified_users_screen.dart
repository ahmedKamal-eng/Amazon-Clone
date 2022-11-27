import 'package:admin_web_portal/functions/functions.dart';
import 'package:admin_web_portal/homeScreen/home_screen.dart';
import 'package:admin_web_portal/widgets/nav_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VerifiedUsersScreen extends StatefulWidget {
  @override
  State<VerifiedUsersScreen> createState() => _VerifiedUsersScreenState();
}

class _VerifiedUsersScreenState extends State<VerifiedUsersScreen> {
  QuerySnapshot? allApprovedUsers;

  getAllVerifiedUsers() async {
     FirebaseFirestore.instance
        .collection("users")
        .where("status", isEqualTo: "approved")
        .get()
        .then((allVerifiedUsers) {
      allApprovedUsers = allVerifiedUsers;
      setState((){});
     }).catchError((e){
      print('++++++++++++++++++++++++++++++++++++++++++++\n'+e.toString());
    });
  }
  
  showDialogBox( userDocumentId ) 
  {
    return showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: const Text('Block Account'),
        content: const Text('Do you want to block this account',
         style: TextStyle(
           fontSize: 16,
           letterSpacing: 2
         ),
        ),
        actions: [
          ElevatedButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text('no')),
          ElevatedButton(onPressed: ()async{
          await   FirebaseFirestore.instance.collection('users').doc(userDocumentId).update(
                {'status':'not approved'}).whenComplete((){
                  Navigator.push(context, MaterialPageRoute(builder: (c)=>HomeScreen()));
                   showReuseableSnack('Blocked successfully', context);
          });

          }, child: Text('yes')),
        ],
      );
    });
    
  }

  @override
  void initState() {
    super.initState();
    getAllVerifiedUsers();
  }

  @override
  Widget build(BuildContext context) {
    Widget verifiedUserDesign() {
      if (allApprovedUsers == null) {
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
                                allApprovedUsers!.docs[index]['photoUrl']),
                          )),
                    ),
                  ),
                  Text(
                    allApprovedUsers!.docs[index]['name'],
                  ),
                  Text(
                    allApprovedUsers!.docs[index]['email'],
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialogBox(allApprovedUsers!.docs[index]['uid']);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('images/block.png',width: 60,),
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
                ],
              ),
            );
          },
          itemCount: allApprovedUsers!.docs.length,
        );
      }
    }

    return Scaffold(
      appBar: NavAppBar(
        title: 'Verified Users Accounts',
      ),
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width * .5,
          child: verifiedUserDesign(),
        ),
      ),
    );
  }
}
