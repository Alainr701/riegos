import 'package:flutter/cupertino.dart';

class AppController extends ChangeNotifier {
  void update() {
    notifyListeners();
  }
}
