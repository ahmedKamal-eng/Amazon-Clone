import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../global/global.dart';
import '../models/brand_model.dart';
import '../models/items_model.dart';
import '../widgets/text_delegate_header_widget.dart';
import 'items_ui_design_widget.dart';

class ItemsScreen extends StatefulWidget {
  Brand? model;

  ItemsScreen({this.model});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
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
        title: Text(
          widget.model!.brandTitle.toString(),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
         automaticallyImplyLeading: true,
      ),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: TextDelegateHeaderWidget(title: 'My '+widget.model!.brandTitle.toString() +'\'s Items'),
          ),

          StreamBuilder(
              stream: FirebaseFirestore.instance.collection('sellers').doc(widget.model!.sellerUid)
                  .collection('brands')
                  .doc(widget.model!.brandId)
                  .collection('items')
                  .orderBy('publishDate',descending: true)
                  .snapshots(),

              builder: ( context , AsyncSnapshot dataSnapshot) {
                if(dataSnapshot.hasData)
                {
                  return SliverStaggeredGrid.countBuilder(
                    crossAxisCount: 1,
                    staggeredTileBuilder: (c)=> const StaggeredTile.fit(1),
                    itemBuilder: (context,index){
                      Item itemModel =Item.fromJson(
                        dataSnapshot.data.docs[index].data() as Map<String,dynamic>,
                      );
                      return ItemsUiDesignWidget(model: itemModel);
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
