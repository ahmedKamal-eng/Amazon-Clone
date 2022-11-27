import 'package:flutter/material.dart';

class LoadingDialog extends StatelessWidget {
 
  String? message;
  LoadingDialog({this.message});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      key: key,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
           padding: EdgeInsets.only(top: 20),
           child: Center(
             child: CircularProgressIndicator(
               valueColor: AlwaysStoppedAnimation(Colors.pinkAccent),
             ),
           ), 
          ),
         const SizedBox(height: 20,),
          Text('$message Please Wait... ')
        ],
      ),
    );
  }
}
