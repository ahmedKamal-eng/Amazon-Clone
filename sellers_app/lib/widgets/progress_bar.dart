import 'package:flutter/material.dart';

linearProgressBar(){
  return Container(
    alignment: Alignment.center,
     padding: EdgeInsets.only(top: 15),
     child: LinearProgressIndicator(

       valueColor: AlwaysStoppedAnimation(Colors.pinkAccent),
     ),
  );
}