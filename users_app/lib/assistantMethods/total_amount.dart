
import 'package:flutter/material.dart';

class TotalAmount extends ChangeNotifier{

  double? total ;

  double? get getTotal=>total;

  showTotal(double t){
    total=t;
    notifyListeners();
  }

}