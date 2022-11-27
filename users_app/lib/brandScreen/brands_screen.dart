import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:users_app/models/seller_model.dart';
import 'package:users_app/widgets/text_delegate_header_widget.dart';


import '../global/global.dart';
import '../models/brand_model.dart';
import '../widgets/my_drawer.dart';

import 'brands_ui_design_widget.dart';

class BrandsScreen extends StatefulWidget {
 Seller? model;
 BrandsScreen({this.model});

  @override
  State<BrandsScreen> createState() => _BrandsScreenState();
}

class _BrandsScreenState extends State<BrandsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      drawer: MyDrawer(),
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
        title: Text(
          'IShop',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: CustomScrollView(
        slivers: [

          SliverPersistentHeader(pinned: true,delegate: TextDelegateHeaderWidget(title: widget.model!.name.toString() +" - brand's")),

          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('sellers')
                  .doc(widget.model!.uid.toString())
                  .collection('brands')
                  .orderBy('publishDate',descending: true)
                  .snapshots(),

              builder: ( context , AsyncSnapshot dataSnapshot) {
                if(dataSnapshot.hasData)
                {
                  return SliverStaggeredGrid.countBuilder(
                    crossAxisCount: 1,
                    staggeredTileBuilder: (c)=> const StaggeredTile.fit(1),
                    itemBuilder: (context,index){
                      Brand brandModel =Brand.fromJson(
                        dataSnapshot.data.docs[index].data() as Map<String,dynamic>,
                      );
                      return BrandsUiDesignWidget(model: brandModel,);
                    },
                    itemCount:  dataSnapshot.data.docs.length ,

                  );

                }
                else
                {
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: Text('No brands to exists'),
                    ),
                  );
                }
              }),
        ],
      ),
    );
  }
}
