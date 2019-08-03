import 'package:appoint/models/period.dart';
import 'package:flutter/material.dart';


class UpdateIsLoadingAction {
  final bool isLoading;

  UpdateIsLoadingAction(this.isLoading);
}

class LoadedPeriodsAction {
  final Map<DateTime, List<Period>> periods;

  LoadedPeriodsAction(this.periods);
}

class LoadPeriodsAction {
  final int companyId;
  final DateTime first;
  final DateTime last;

  LoadPeriodsAction(this.companyId, this.first, this.last);
}

class ResetSelectPeriodViewModelAction {}

class UpdateSelectedDayPeriodsAction {
  final List selectedDayPeriods;

  UpdateSelectedDayPeriodsAction(this.selectedDayPeriods);
}

class UpdateVisibilityFilterAction {
  final DateTime visibleFirstDay;
  final DateTime visibleLastDay;

  UpdateVisibilityFilterAction(
      this.visibleFirstDay, this.visibleLastDay);
}

class UpdateTimeFilterAction {
  final TimeOfDay timeFilter;

  UpdateTimeFilterAction(this.timeFilter);
}

class UpdateSelectedDayAction {
  final DateTime day;

  UpdateSelectedDayAction(this.day);
}

class LoadPeriodTilesAction {
  BuildContext context;
  DateTime day;

  LoadPeriodTilesAction(
    this.context,
    this.day,
  );
}
