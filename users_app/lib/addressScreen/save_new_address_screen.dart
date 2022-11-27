import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:users_app/addressScreen/text_field_address_widget.dart';
import 'package:users_app/global/global.dart';

class SaveNewAddressScreen extends StatefulWidget {
  String? sellerUid;
  double? total;

  SaveNewAddressScreen({this.sellerUid, this.total});

  @override
  State<SaveNewAddressScreen> createState() => _SaveNewAddressScreenState();
}

class _SaveNewAddressScreenState extends State<SaveNewAddressScreen> {
  TextEditingController name = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController streetNumber = TextEditingController();
  TextEditingController flatHouseNumber = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController stateCountry = TextEditingController();
  String completeAddress = '';
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
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
        title: const Text(
          'iShop',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            completeAddress = streetNumber.text.trim() +
                ", " +
                flatHouseNumber.text.trim() +
                ", " +
                city.text.trim() +
                ', ' +
                stateCountry.text.trim();
            FirebaseFirestore.instance
                .collection('users')
                .doc(sharedPreferences!.getString('uid'))
                .collection('userAddress')
                .doc(DateTime.now().millisecondsSinceEpoch.toString())
                .set({
              'name': name.text.trim(),
              'phoneNumber': phoneNumber.text.trim(),
              'streetNumber': streetNumber.text.trim(),
              'flatHouseNumber': flatHouseNumber.text.trim(),
              'city': city.text.trim(),
              'stateCountry': stateCountry.text.trim(),
               'completeAddress':completeAddress
            }).then((value) {
              Fluttertoast.showToast(msg: 'address has been saved',backgroundColor: Colors.tealAccent,textColor: Colors.black);
              formKey.currentState!.reset();
            });
          }
        },
        label: Text('Save New'),
        icon: Icon(Icons.save),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                'Save New Address :',
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFieldAddressWidget(
                    hint: 'name',
                    controller: name,
                  ),
                  TextFieldAddressWidget(
                    hint: 'phoneNumber',
                    controller: phoneNumber,
                  ),
                  TextFieldAddressWidget(
                    hint: 'street number',
                    controller: streetNumber,
                  ),
                  TextFieldAddressWidget(
                    hint: 'flat /house number',
                    controller: flatHouseNumber,
                  ),
                  TextFieldAddressWidget(
                    hint: 'city',
                    controller: city,
                  ),
                  TextFieldAddressWidget(
                    hint: 'state/ country',
                    controller: stateCountry,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
