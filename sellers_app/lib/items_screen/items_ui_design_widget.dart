import 'package:flutter/material.dart';
import 'package:sellers_app/items_screen/items_screen.dart';
import 'package:sellers_app/models/brand_model.dart';
import 'package:sellers_app/models/items_model.dart';

import 'items_details_screen.dart';

class ItemsUiDesignWidget extends StatefulWidget {
  Item? model;
  BuildContext? context;

  ItemsUiDesignWidget({this.model, this.context});

  @override
  State<ItemsUiDesignWidget> createState() => _ItemsUiDesignWidgetState();
}

class _ItemsUiDesignWidgetState extends State<ItemsUiDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ItemsDetailsScreen(model: widget.model,)));
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
                Text(
                  widget.model!.itemTitle.toString(),
                  style: const TextStyle(
                    fontSize: 20,
                    letterSpacing: 3,
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2,),
                Image.network(widget.model!.thumbnailsUrl.toString(),height: 220,),
                const SizedBox(
                  height: 1,
                ),
                Text(
                  widget.model!.itemInfo.toString(),
                  style: const TextStyle(
                    fontSize: 20,
                    letterSpacing: 3,
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}













