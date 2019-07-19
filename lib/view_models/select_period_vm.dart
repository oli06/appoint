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