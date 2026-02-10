import 'package:flutter/material.dart';

class AppMode extends ChangeNotifier {
  bool _isBookingMode = true;

  bool get isBookingMode => _isBookingMode;
  bool get isSocialMode => !_isBookingMode;

  void toggleMode() {
    _isBookingMode = !_isBookingMode;
    notifyListeners();
  }

  void setBookingMode() {
    _isBookingMode = true;
    notifyListeners();
  }

  void setSocialMode() {
    _isBookingMode = false;
    notifyListeners();
  }
}
