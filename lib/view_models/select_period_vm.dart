import 'package:appoint/models/period.dart';
import 'package:flutter/material.dart';

class SelectedPeriodViewModel {
  final Map<DateTime, List<Period>> periods;
  final Map<DateTime, List> visiblePeriods;

  final bool isLoading;
  final TimeOfDay timeFilter;
  final bool prioritizePrivateAppointments;
  final DateTime visibleFirstDay;
  final DateTime visibleLastDay;
  final DateTime selectedDay;

  const SelectedPeriodViewModel({
    this.periods,
    this.visiblePeriods,
    this.isLoading,
    this.timeFilter,
    this.prioritizePrivateAppointments,
    this.visibleFirstDay,
    this.visibleLastDay,
    this.selectedDay,
  });
}

/* class PeriodMode {
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
} */