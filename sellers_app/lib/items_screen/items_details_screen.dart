import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sellers_app/splashScreen/my_splash_screen.dart';

import '../global/global.dart';
import '../models/items_model.dart';

class ItemsDetailsScreen extends StatefulWidget {

  Item? model;
  ItemsDetailsScreen({this.model});

  @override
  State<ItemsDetailsScreen> createState() => _ItemsDetailsScreenState();

}

class _ItemsDetailsScreenState extends State<ItemsDetailsScreen> {


  deleteItem(){
    FirebaseFirestore.instance
        .collection('sellers')
        .doc(sharedPreferences!.getString('uid'))
        .collection('brands')
        .doc(widget.model!.brandId)
        .collection('items')
        .doc(widget.model!.itemId).delete().then((value) {

          FirebaseFirestore.instance.collection('items').doc(widget.model!.itemId).delete();

          Fluttertoast.showToast(msg: 'item deleted successfully',backgroundColor: Colors.teal);
          Navigator.push(context, MaterialPageRoute(builder: (c)=>MySplashScreen()));
    });

  }

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.pink, Colors.purpleAccent],
                  begin: FractionalOffset(0.0, 0.0),
                  end: FractionalOffset(1.0, 0.0),
                  stops: [0.0, 1.0],
                  tileMode: TileMode.clamp),
            ),
          ),
          title: Text(widget.model!.itemTitle!),
          centerTitle: true,

        ),
        floatingActionButton: FloatingActionButton.extended(onPressed: (){
          deleteItem();
        },
            label:const Text('Delete this item'),
            icon: Icon(Icons.delete_sweep),
          backgroundColor: Colors.pink,

        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: Image.network(widget.model!.thumbnailsUrl!,width: 200,)),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(widget.model!.itemTitle! + ' :',

                style:const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  color: Colors.deepPurple
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(widget.model!.longDescription!,
                textAlign: TextAlign.justify,
                style:const TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 15
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12,bottom: 10),
              child: Text(widget.model!.price! +' E£',
                textAlign: TextAlign.justify,
                style:const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                  color: Colors.pink
                ),
              ),
            ),
            const Padding(
              padding:  EdgeInsets.only(left: 12,right: 300),
              child: Divider(height: 1,thickness: 2,color: Colors.purpleAccent,),
            )
          ],

        ),
      );
  }
}
