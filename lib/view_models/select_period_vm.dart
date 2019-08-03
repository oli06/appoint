import 'package:appoint/models/period.dart';
import 'package:flutter/material.dart';

class SelectedPeriodViewModel {
  final bool isLoading;

  final TimeOfDay timeFilter;
  final Map<DateTime, List<Period>> periods;

  ///date range of visible Days, e.g. first of month till last of month
  final DateTime visibleFirstDay;
  final DateTime visibleLastDay;
  final DateTime selectedDay;

  const SelectedPeriodViewModel({
    this.isLoading,
    this.periods,
    this.timeFilter,
    this.visibleFirstDay,
    this.visibleLastDay,
    this.selectedDay,
  });
}
