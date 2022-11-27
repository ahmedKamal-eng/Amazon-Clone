
import 'package:flutter/material.dart';

showReuseableSnack(String? content,BuildContext context)
{
  SnackBar snackBar =  SnackBar(
    content: Text(content!,
      style:const TextStyle(fontSize: 20, color: Colors.white),
    ),
    duration:const Duration(seconds: 2),
    backgroundColor: Colors.deepPurple,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}