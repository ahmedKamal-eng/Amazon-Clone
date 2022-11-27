import 'package:flutter/material.dart';
import 'package:users_app/models/items_model.dart';

class CartItemDesignWidget extends StatefulWidget {
  Item? model;
  int? quantityNumber;
  CartItemDesignWidget({this.model, this.quantityNumber});

  @override
  State<CartItemDesignWidget> createState() => _CartItemDesignWidgetState();
}

class _CartItemDesignWidgetState extends State<CartItemDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      shadowColor: Colors.white54,
      elevation: 10,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 100,
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              Image.network(
                widget.model!.thumbnailsUrl.toString(),
                width: 140,
                height: 120,
              ),
              const SizedBox(
                width: 15,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.model!.itemTitle.toString(),
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  //price
                  Row(
                    children: [
                      const Text(
                        "Price: ",
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        widget.model!.price.toString(),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        ' E£',
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  //quantity
                  Row(
                    children: [
                     const Text(
                        'Quantity :',
                        style: TextStyle(
                          color: Colors.white54,
                          fontSize: 18,
                        ),
                      ),
                      Text(widget.quantityNumber!.toString(),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.bold
                        ),
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
