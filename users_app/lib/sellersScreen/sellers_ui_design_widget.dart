import 'package:flutter/material.dart';
import 'package:smooth_star_rating_nsafe/smooth_star_rating.dart';
import 'package:users_app/brandScreen/brands_screen.dart';
import 'package:users_app/models/seller_model.dart';

class SellersUiDesignWidget extends StatefulWidget {
  Seller? model;
  SellersUiDesignWidget({this.model});

  @override
  State<SellersUiDesignWidget> createState() => _SellersUiDesignWidgetState();
}

class _SellersUiDesignWidgetState extends State<SellersUiDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>BrandsScreen(model: widget.model,)));
        },
      child: Card(
        color: Colors.black54,
        shadowColor: Colors.grey,
        elevation: 20,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox(
            height: 270,
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    widget.model!.photoUrl.toString(),
                    height: 220,
                    fit: BoxFit.fill,
                  ),
                ),
                const SizedBox(
                  height: 1,
                ),
                Text(
                  widget.model!.name.toString(),
                  style: const TextStyle(
                      color: Colors.pink,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                SmoothStarRating(
                  rating: widget.model!.rating == null
                      ? 0.0
                      : double.parse(widget.model!.rating.toString()),
                  allowHalfRating: true,
                  starCount: 5,
                  color: Colors.pinkAccent,
                  borderColor: Colors.pinkAccent,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
