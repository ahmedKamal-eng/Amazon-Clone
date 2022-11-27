import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:users_app/assistantMethods/cart_item_counter.dart';
import 'package:users_app/cartScreen/cart_screen.dart';

class AppBarWithCartBadge extends StatefulWidget with PreferredSizeWidget {
  PreferredSizeWidget? preferredSizeWidget;
  String? sellerUid;

  AppBarWithCartBadge({this.preferredSizeWidget, this.sellerUid});

  @override
  State<AppBarWithCartBadge> createState() => _AppBarWithCartBadgeState();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => preferredSizeWidget == null
      ? Size(56, AppBar().preferredSize.height)
      : Size(56, 80 + AppBar().preferredSize.height);
}

class _AppBarWithCartBadgeState extends State<AppBarWithCartBadge> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      flexibleSpace: Container(
        //make a gradient color
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.pinkAccent, Colors.purpleAccent],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp),
        ),
      ),
      // automaticallyImplyLeading: true,
      title: const Text(
        'iShop',
        style: TextStyle(fontSize: 20, letterSpacing: 3),
      ),
      centerTitle: true,
      actions: [
        Stack(
          children: [
            IconButton(
              onPressed: () {

                int itemInCart=Provider.of<CartItemCounter>(context,listen: false).count;

                if(itemInCart ==0)
                  {
                    Fluttertoast.showToast(msg: 'there is no item in the cart',backgroundColor: Colors.redAccent);
                  }
                else
                {
                  Navigator.push(context, MaterialPageRoute(builder: (c)=>CartScreen(sellerUID: widget.sellerUid,)));
                }
              },
              icon: const Icon(Icons.shopping_cart),
            ),
            Positioned(
              child: Stack(
                children: [
                  const Icon(
                    Icons.brightness_1,
                    size: 22,
                    color: Colors.deepPurple,
                  ),
                  Positioned(
                    top: 2,
                    right: 6,
                    child: Consumer<CartItemCounter>(
                      builder: (context, counter, c) {
                        return Text(counter.count.toString(),
                           style:const TextStyle(
                               color: Colors.white
                           ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        )
      ],
    );
  }
}
