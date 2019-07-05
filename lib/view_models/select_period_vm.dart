import 'package:appoint/models/period.dart';
import 'package:flutter/material.dart';

class SelectPeriodViewModel {
  final List<Period> periods;
  final PeriodMode periodModel;
  final bool isLoading;
  final List<bool> filter;

  const SelectPeriodViewModel({
    this.periods,
    this.periodModel,
    this.isLoading,
    this.filter,
  });
}

class PeriodMode {
  SelectedPeriodMode _mode = SelectedPeriodMode.DATE;
  SelectedPeriodMode get mode => _mode;

  DateTime _date;
  TimeOfDay _time;

  DateTime get date => _date;
  TimeOfDay get time => _time;

  PeriodMode({DateTime date, TimeOfDay time, SelectedPeriodMode mode}) {
    _date = date ?? DateTime.now().add(Duration(days: 1));
    _time = time ?? TimeOfDay(hour: 8, minute: 0);
    _mode = mode;
  }

  dynamic getSelectedValue() {
    return _mode == SelectedPeriodMode.DATE ? _date : _time;
  }

}

enum SelectedPeriodMode {
  DATE,
  TIME,
}