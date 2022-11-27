
import 'package:flutter/material.dart';

class TextFieldAddressWidget extends StatelessWidget {

  String? hint;
  TextEditingController? controller;

  TextFieldAddressWidget({this.hint,this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: TextFormField(
        controller: controller,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration.collapsed(
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.grey,
            decorationColor: Colors.white

          ),

        ),
      validator: (val)=> val!.isEmpty ? 'field can not be empty': null,
      ),
    );

  }
}
