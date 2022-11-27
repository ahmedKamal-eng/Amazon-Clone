import 'package:cart_stepper/cart_stepper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:users_app/assistantMethods/cart_methods.dart';
import 'package:users_app/widgets/appbar_cart_badge.dart';
import '../global/global.dart';
import '../models/items_model.dart';
import '../splashScreen/my_splash_screen.dart';

class ItemsDetailsScreen extends StatefulWidget {

  Item? model;
  ItemsDetailsScreen({this.model});

  @override
  State<ItemsDetailsScreen> createState() => _ItemsDetailsScreenState();

}

class _ItemsDetailsScreenState extends State<ItemsDetailsScreen> {


  int counterLimit=1;



  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        backgroundColor: Colors.black,
        appBar:AppBarWithCartBadge(
          sellerUid:widget.model!.sellerUID ,
          // preferredSizeWidget: ,
        ),
        floatingActionButton: FloatingActionButton.extended(onPressed: (){

          int itemCount=counterLimit;

          List<String> itemsIDs=cartMethods.separateItemIdsFromUserCartList();

          if(itemsIDs.contains('${widget.model!.itemId}'))
            {
              Fluttertoast.showToast(msg: 'Item is already exist',backgroundColor: Colors.redAccent);
            }
          else
            {

              // add item to the cart
              cartMethods.addItemToCart(widget.model!.itemId.toString()
                  ,itemCount,context
              );

            }



        },
            label:const Text('Add to cart'),
            icon: Icon(Icons.add_shopping_cart_outlined),
          backgroundColor: Colors.pink,

        ),
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(child: Image.network(widget.model!.thumbnailsUrl!,height: 200,)),
              SizedBox(height: 20,),
              Center(
                child: CartStepperInt(
                  size: 50,
                  value: counterLimit,
                  didChangeCount: (val){
                    if(val <1){
                      Fluttertoast.showToast(msg: 'the quantity cannot be less than 1',backgroundColor: Colors.red);
                      return;
                    }

                    setState((){
                      counterLimit=val;
                    });

                  },

                ),
              ),
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
                    color: Colors.white,
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
              ),
              const SizedBox(height: 100,),

            ],

          ),
        ),
      );
  }
}
