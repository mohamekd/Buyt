import 'package:flutter/foundation.dart';

class ItemQuantity with ChangeNotifier {
  int _numberOFItems = 0;
  int get numberOfItems => _numberOFItems;
  display(int num){
    _numberOFItems = num;
    notifyListeners();
  }
}
