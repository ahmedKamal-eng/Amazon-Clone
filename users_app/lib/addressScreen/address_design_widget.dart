import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users_app/assistantMethods/address_changer.dart';
import 'package:users_app/models/address.dart';
import 'package:users_app/placeOrderScreen/place_order_screen.dart';

class AddressDesignWidget extends StatefulWidget {
  Address? addressModel;
  int? index;
  int? value;
  String? addressID;
  double? totalAmount;
  String? sellerUID;

  AddressDesignWidget(
      {this.addressModel,
      this.index,
      this.value,
      this.addressID,
      this.totalAmount,
      this.sellerUID});

  @override
  State<AddressDesignWidget> createState() => _AddressDesignWidgetState();
}

class _AddressDesignWidgetState extends State<AddressDesignWidget> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white38,
      child: Column(
        children: [
          Row(
            children: [
              Radio(
                value: widget.value!,
                groupValue: widget.index,
                activeColor: Colors.pink,
                onChanged: (val) {
                  Provider.of<AddressChanger>(context, listen: false)
                      .showSelectedAddress(val);
                },
              ),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: MediaQuery.of(context).size.width * .8,
                    child: Table(
                      children: [
                        TableRow(
                          children: [
                            const Text(
                              'name :',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              widget.addressModel!.name.toString(),
                            ),
                          ],
                        ),
                        const TableRow(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            const Text(
                              'phoneNumber :',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              widget.addressModel!.phoneNumber.toString(),
                            ),
                          ],
                        ),
                        const TableRow(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            const Text(
                              'Full Address :',
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              widget.addressModel!.completeAddress.toString(),
                            ),
                          ],
                        ),
                        const TableRow(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          widget.value == Provider.of<AddressChanger>(context).count
              ? ElevatedButton(
                  child: const Text('Proceed'),
                  style: ElevatedButton.styleFrom(primary: Colors.purpleAccent,),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (c)=>PlaceOrderScreen(addressID: widget.addressID,totalAmount: widget.totalAmount,sellerUID: widget.sellerUID,)));
                    },
                )
              : Container(),
        ],
      ),
    );
  }
}
