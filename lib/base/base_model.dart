import 'package:appoint/base/viewstate_enum.dart';
import 'package:flutter/material.dart';

class BaseModel extends ChangeNotifier {
  ViewState _state = ViewState.Idle;

  ViewState get state => _state;

  void setState(ViewState newState) {
    if(_state == newState) {
      return;
    }

    _state = newState;
    notifyListeners();
  }
}