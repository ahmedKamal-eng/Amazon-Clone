import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sellers_app/items_screen/items_screen.dart';
import 'package:sellers_app/models/brand_model.dart';
import 'package:sellers_app/splashScreen/my_splash_screen.dart';

import '../global/global.dart';

class BrandsUiDesignWidget extends StatefulWidget {
  Brand? model;
  BuildContext? context;

  BrandsUiDesignWidget({this.model, this.context});

  @override
  State<BrandsUiDesignWidget> createState() => _BrandsUiDesignWidgetState();
}

class _BrandsUiDesignWidgetState extends State<BrandsUiDesignWidget> {
  
  deleteBrand() {
     FirebaseFirestore.instance.collection('sellers').doc(sharedPreferences!.getString('uid')).collection('brands').doc(widget.model!.brandId).delete();
     Fluttertoast.showToast(msg: 'brand deleted successfully',backgroundColor: Colors.teal);
     Navigator.push(context , MaterialPageRoute(builder: (context)=>MySplashScreen()));
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ItemsScreen(model: widget.model,)));
      },
      child: Card(
        elevation: 10,
        shadowColor: Colors.black,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: SizedBox(
            height: 270,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                Image.network(widget.model!.thumbnailUrl.toString(),height: 220,),
                const SizedBox(
                  height: 1,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.model!.brandTitle.toString(),
                      style: const TextStyle(
                        fontSize: 20,
                        letterSpacing: 3,
                        color: Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          deleteBrand();
                        },
                        icon:const Icon(
                          Icons.delete_sweep,
                          color: Colors.pinkAccent,
                        ))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}













