import 'package:flutter/material.dart';

import '../models/items_model.dart';
import 'items_details_screen.dart';


class ItemsUiDesignWidget extends StatefulWidget {
  Item? model;


  ItemsUiDesignWidget({this.model,});

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
        color: Colors.black,

        elevation: 10,
        shadowColor: Colors.grey,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SizedBox(
            height: 310,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: Image.network(widget.model!.thumbnailsUrl.toString(),height: 220,)),

                SizedBox(height: 2,),

                Text(
                  widget.model!.itemTitle.toString(),
                  style: const TextStyle(
                    fontSize: 20,
                    letterSpacing: 3,
                    color: Colors.deepPurple,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 1,
                ),
                Text(
                  widget.model!.itemInfo.toString(),
                  style: const TextStyle(
                    fontSize: 16,
                    letterSpacing: 3,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5,),
                Text(widget.model!.price!,style:const TextStyle(fontSize: 22,color: Colors.pink),)

              ],
            ),
          ),
        ),
      ),
    );
  }
}













