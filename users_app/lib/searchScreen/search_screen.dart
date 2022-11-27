import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:users_app/sellersScreen/sellers_ui_design_widget.dart';

import '../models/seller_model.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String sellerNameText = '';
  Future<QuerySnapshot>? storesDocumentList;

  initializeSearchingStores(String text)  {
   storesDocumentList=   FirebaseFirestore.instance
        .collection('sellers')
        .where('name', isGreaterThanOrEqualTo: text)
        .get();
  }

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
        title: TextField(
          onChanged: (textEntered) {
            sellerNameText = textEntered;
            setState(() {});
            initializeSearchingStores(sellerNameText);

          },
          decoration: InputDecoration(
              hintText: 'Search seller here ..',
              hintStyle: const TextStyle(color: Colors.white),
              suffixIcon: IconButton(
                onPressed: () {
                  initializeSearchingStores(sellerNameText);
                },
                color: Colors.white,
                icon: const Icon(Icons.search),
              )),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      body: FutureBuilder(
        future: storesDocumentList,
        builder: (context,AsyncSnapshot snapshot){
          if(snapshot.hasData)
            {
              return ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context,index){
                    Seller model=Seller.fromJson(snapshot.data.docs[index].data() as Map<String,dynamic>);
                    return SellersUiDesignWidget(model: model,);
                  });
            }
          else
            {
              return const Center(
                child: Text('No record found...',style: TextStyle(color: Colors.white),),
              );
            }
        },

      ),
    );
  }
}
