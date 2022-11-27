import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users_app/addressScreen/address_design_widget.dart';
import 'package:users_app/addressScreen/save_new_address_screen.dart';
import 'package:users_app/assistantMethods/address_changer.dart';
import 'package:users_app/global/global.dart';

import '../models/address.dart';

class AddressScreen extends StatefulWidget {
  String? sellerUid;
  double? totalAmount;

  AddressScreen({this.totalAmount, this.sellerUid});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        flexibleSpace: Container(
          //make a gradient color
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.pinkAccent, Colors.purpleAccent],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp),
          ),
        ),
        title: const Text(
          'iShop',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (c) => SaveNewAddressScreen(
                        sellerUid: widget.sellerUid,
                        total: widget.totalAmount,
                      )));
        },
        label: Text('Add new location'),
        icon: Icon(Icons.add_location),
      ),
      body: Column(
        children: [
          Consumer<AddressChanger>(builder: (context, address, c) {
            return Flexible(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(sharedPreferences!.getString('uid'))
                    .collection('userAddress')
                    .snapshots(),
                builder: (context,AsyncSnapshot dataSnapshot) {
                   if(dataSnapshot.hasData)
                     {

                       if(dataSnapshot.data.docs.length > 0)
                         {
                           return ListView.builder(itemBuilder: (context,index){
                               return  AddressDesignWidget(
                                 addressModel: Address.fromJson(dataSnapshot.data.docs[index].data() as Map<String,dynamic>),
                                 index: address.count,
                                 value: index,
                                 addressID: dataSnapshot.data.docs[index].id,
                                 totalAmount: widget.totalAmount,
                                 sellerUID: widget.sellerUid,
                               );
                           },
                             itemCount: dataSnapshot.data.docs.length,
                           );
                         }
                       else{
                         return const Center(child: Text('there is no data'),);
                       }

                     }
                   else
                     {
                         return const Center(child: Text('there is no data'),);
                     }
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
