import 'package:appoint/model/period.dart';
import 'package:flutter/material.dart';

class SelectPeriodViewModel {
  final List<Period> periods;
  final PeriodMode periodModel;

  const SelectPeriodViewModel({
    this.periods,
    this.periodModel,
  });
}

class PeriodMode {
  SelectedPeriodMode _mode;
  SelectedPeriodMode get mode => _mode;

  DateTime _date;
  TimeOfDay _time;

  PeriodMode({@required SelectedPeriodMode mode, dynamic value}) {
    this._updateMode(mode, value);
  }

  dynamic getSelectedValue() {
    return _mode == SelectedPeriodMode.DATE ? _date : _time;
  }

  _updateMode(SelectedPeriodMode mode, dynamic value) {
    _mode = mode;
    _setSelectedValue(value);
  }

  _setSelectedValue(dynamic value) {
    if (_mode == SelectedPeriodMode.DATE) {
      _date = value as DateTime;
    } else if (_mode == SelectedPeriodMode.TIME) {
      _time = value as TimeOfDay;
    }
  }
}

enum SelectedPeriodMode {
  DATE,
  TIME,
}
