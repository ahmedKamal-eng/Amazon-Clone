import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:users_app/ordersScreen/order_details_screen.dart';

import '../models/items_model.dart';

class OrderCard extends StatefulWidget {
  int? intCount;
  List<DocumentSnapshot>? data;
  String? orderId;
  List<String>? seperateQuantitiesList;

  OrderCard(
      {this.intCount, this.data, this.orderId, this.seperateQuantitiesList});

  @override
  State<OrderCard> createState() => _OrderCardState();
}

class _OrderCardState extends State<OrderCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: GestureDetector(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (c)=>OrderDetailsScreen(orderId: widget.orderId,)));
        },
        child: Card(
          color: Colors.black54,

          elevation: 10,
          shadowColor: Colors.white54,
          child: Container(
            color: Colors.transparent,
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(10),
            height: widget.intCount! * 125,
            child: ListView.builder(
                itemCount: widget.intCount,
                itemBuilder: (context, index) {
                  Item model = Item.fromJson(
                      widget.data![index].data() as Map<String, dynamic>);
                  return placedOrderItemsDesignWedgit(
                    model,
                    context,
                    widget.seperateQuantitiesList
                  );
                }),
          ),
        ),
      ),
    );
  }
}

Widget placedOrderItemsDesignWedgit(
  Item item,
  BuildContext context,
    separateQuantitiesList
) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 130,
    color: Colors.transparent,
    child: Row(
      children: [
        ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: Image.network(
              item.thumbnailsUrl.toString(),
              width: 120,
            )),
        const SizedBox(
          width: 12,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  item.itemTitle.toString(),
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  'E£',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.pink),
                ),
                const SizedBox(
                  width: 2,
                ),
                Text(
                  item.price.toString(),
                  style: TextStyle(fontSize: 16, color: Colors.pink),
                ),
              ],
            ),
            const SizedBox(height: 20,),
            Row(
              children: [
                const Text(
                  'X',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text( separateQuantitiesList.length.toString()
                  ,
                  style: TextStyle(fontSize: 26, color: Colors.grey),
                ),
              ],
            ),

          ],
        )
      ],
    ),
  );
}
