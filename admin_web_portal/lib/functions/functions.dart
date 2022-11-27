
import 'package:flutter/material.dart';

showReuseableSnack(String? content,BuildContext context)
{
  SnackBar snackBar =  SnackBar(
    content: Text(content!,
      style: TextStyle(fontSize: 36, color: Colors.white),
    ),
    duration: Duration(seconds: 2),
    backgroundColor: Colors.deepPurple,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}