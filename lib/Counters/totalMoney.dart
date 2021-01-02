import 'package:flutter/cupertino.dart';

class TotalAmount extends ChangeNotifier{
  double _totalAmount = 0;
  double get totalAmount => _totalAmount;
  display(double num) async{
    _totalAmount = num;

    await Future.delayed(const Duration(microseconds: 100),(){
      notifyListeners();
    });

  }
}