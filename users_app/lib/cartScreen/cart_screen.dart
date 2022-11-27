import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users_app/addressScreen/address_screen.dart';
import 'package:users_app/assistantMethods/total_amount.dart';
import 'package:users_app/cartScreen/cart_item_design_widget.dart';
import 'package:users_app/global/global.dart';
import 'package:users_app/splashScreen/my_splash_screen.dart';
import 'package:users_app/widgets/appbar_cart_badge.dart';

import '../models/items_model.dart';

class CartScreen extends StatefulWidget {
  String? sellerUID;
  CartScreen({this.sellerUID});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<int>? itemQuantityList;
  double totalAmount = 0.0;

  @override
  void initState() {
    super.initState();
    Provider.of<TotalAmount>(context, listen: false).showTotal(0);

    itemQuantityList = cartMethods.separateItemQuantitiesFromUserCartList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBarWithCartBadge(),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const SizedBox(), //don't set the width because spaceAround
          FloatingActionButton.extended(
            onPressed: () {
              cartMethods.clearCart(context);
              Navigator.push(
                  context, MaterialPageRoute(builder: (c) => MySplashScreen()));
            },
            heroTag: 'btn1',
            label: const Text('Clear Cart'),
            icon: Icon(Icons.clear_all),
          ),
          FloatingActionButton.extended(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (c) => AddressScreen(
                            sellerUid: widget.sellerUID.toString(),
                            totalAmount: totalAmount,
                          )));
            },
            heroTag: 'btn2',
            label: const Text('Check Out'),
            icon: Icon(Icons.navigate_next),
          ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              color: Colors.black54,
              child: Consumer<TotalAmount>(builder: (context, t, c) {
                return Center(
                    child: Text(
                  'total Price: ' + '${t.total!.toStringAsFixed(2)}',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ));
              }),
            ),
          ),
          StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('items')
                  .where('itemId',
                      whereIn: cartMethods.separateItemIdsFromUserCartList())
                  .orderBy('publishDate', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot dataSnapshot) {
                if (dataSnapshot.hasData) {
                  return SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        Item model = Item.fromJson(dataSnapshot.data.docs[index]
                            .data() as Map<String, dynamic>);
                        if (index == 0) {
                          totalAmount = 0;
                          totalAmount = double.parse(model.price!) *
                              itemQuantityList![index];
                        } else {
                          totalAmount = (totalAmount +
                              double.parse(model.price!) *
                                  itemQuantityList![index]);
                        }

                        if (dataSnapshot.data.docs.length - 1 == index) {
                          WidgetsBinding.instance.addTimingsCallback((timings) {
                            Provider.of<TotalAmount>(context, listen: false)
                                .showTotal(totalAmount);
                          });
                        }

                        return CartItemDesignWidget(
                          model: model,
                          quantityNumber: itemQuantityList![index],
                        );
                      },
                      childCount: dataSnapshot.data.docs.length,
                    ),
                  );
                } else {
                  return const SliverToBoxAdapter(
                    child: Center(
                      child: Text('No items in your cart'),
                    ),
                  );
                }
              }),
        ],
      ),
    );
  }
}
