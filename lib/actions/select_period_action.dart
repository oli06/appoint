import 'package:appoint/models/period.dart';
import 'package:appoint/view_models/select_period_vm.dart';
import 'package:flutter/material.dart';

class SetLoadedPeriodsAction {
  final List<Period> periods;

  SetLoadedPeriodsAction(this.periods);
}

class UpdateIsLoadingAction {
  final bool isLoading;

  UpdateIsLoadingAction(this.isLoading);
}

class LoadPeriodsAction {
  final int companyId;
  final int month;
  LoadPeriodsAction(this.companyId, this.month);
}

class UpdateVisiblePeriodsAction {
  final Map<DateTime, List> visiblePeriods;

  UpdateVisiblePeriodsAction(
    this.visiblePeriods,
  );
}

class UpdateSelectedDayPeriodsAction {
  final List selectedDayPeriods;

  UpdateSelectedDayPeriodsAction(this.selectedDayPeriods);
}

class UpdateVisibilityFilterAction {
  final DateTime visibleFirstDay;
  final DateTime visibleLastDay;

  UpdateVisibilityFilterAction(this.visibleFirstDay, this.visibleLastDay);
}

class UpdateTimeFilterAction {
  final TimeOfDay timeFilter;

  UpdateTimeFilterAction(this.timeFilter);
}

class UpdateSelectedDayAction {
  final DateTime day;

  UpdateSelectedDayAction(this.day);
}

class UpdatePrioritizePrivateAppointmentsAction {
  final bool prioritizePrivate;

  UpdatePrioritizePrivateAppointmentsAction(this.prioritizePrivate);
}
