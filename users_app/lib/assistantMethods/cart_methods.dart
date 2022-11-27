import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:users_app/assistantMethods/cart_item_counter.dart';
import 'package:users_app/global/global.dart';
import 'package:provider/provider.dart';

class CartMethods {
  addItemToCart(String? itemID, int itemCounter, BuildContext context) {
    List<String>? tempList = sharedPreferences!.getStringList('userCart');
    tempList!.add(itemID.toString() + ' : ' + itemCounter.toString());

    //save to firestore

    FirebaseFirestore.instance
        .collection('users')
        .doc(sharedPreferences!.getString('uid'))
        .update({'userCart': tempList}).then((value) {

          Fluttertoast.showToast(msg: 'Item added successfully');

          sharedPreferences!.setStringList('userCart', tempList);

          Provider.of<CartItemCounter>(context,listen: false).showCartListItemsNumber();
          separateItemIdsFromUserCartList();
          separateItemQuantitiesFromUserCartList();

    });
  }

  clearCart(BuildContext context){
    sharedPreferences!.setStringList('userCart', ['initialValue']);
    List<String>? emptyList=sharedPreferences!.getStringList('userCart');

    FirebaseFirestore.instance.collection('users').doc(sharedPreferences!.getString('uid')).update(
        {'userCart':emptyList}).then((value) {

      Provider.of<CartItemCounter>(context,listen: false).showCartListItemsNumber();

    });
  }

 List<String> separateItemIdsFromUserCartList(){
     List<String>? userCartList=sharedPreferences!.getStringList('userCart');
     List<String> itemsIDsList=[];

     for(int i=1;i<userCartList!.length;i++)
       {
         String item=userCartList[i].toString();
         var colonIndex=item.lastIndexOf(':');
         String itemId=item.substring(0,colonIndex-1);// -1 to delete the space

         itemsIDsList.add(itemId);
       }
     print('items ids list');
     print(itemsIDsList);
     return itemsIDsList;

  }


  separateItemQuantitiesFromUserCartList(){
     List<String>? userCartList=sharedPreferences!.getStringList('userCart');
     List<int> itemsQuantitiesList=[];

     for(int i=1;i<userCartList!.length;i++)
       {
         String item=userCartList[i].toString();
         int colonIndex=item.lastIndexOf(':');
         int itemId=int.parse(item.substring(colonIndex +1));

         itemsQuantitiesList.add(itemId);
       }
     print('items quantities list');
     print(itemsQuantitiesList);
     return itemsQuantitiesList;

  }


  List<String> separateOrdersItemIds( productIDS ){
    List<String>? userCartList=List<String>.from(productIDS);
    List<String> itemsIDsList=[];

    for(int i=1;i<userCartList.length;i++)
    {
      String item=userCartList[i].toString();
      var colonIndex=item.lastIndexOf(':');
      String itemId=item.substring(0,colonIndex-1);// -1 to delete the space

      itemsIDsList.add(itemId);
    }
    print('items ids list');
    print(itemsIDsList);
    return itemsIDsList;

  }

  separateOrderItemQuantities( productIDS){
    List<String>? userCartList=List<String>.from(productIDS);
    List<String> itemsQuantitiesList=[];

    for(int i=1;i<userCartList.length;i++)
    {
      String item=userCartList[i].toString();
      int colonIndex=item.lastIndexOf(':');
      int itemId=int.parse(item.substring(colonIndex +1));

      itemsQuantitiesList.add(itemId.toString());
    }
    print('items quantities list');
    print(itemsQuantitiesList);
    return itemsQuantitiesList;

  }

}
