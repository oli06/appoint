import 'package:appoint/models/period.dart';
import 'package:appoint/widgets/expandable_period_tile.dart';
import 'package:flutter/material.dart';

class SetLoadedPeriodsAction {
  final Map<DateTime, List<Period>> days;

  SetLoadedPeriodsAction(this.days);
}

class UpdateIsLoadingAction {
  final bool isLoading;

  UpdateIsLoadingAction(this.isLoading);
}

class LoadPeriodsAction {
  final int companyId;
  final DateTime month;
  LoadPeriodsAction(this.companyId, this.month);
}

class UpdateVisiblePeriodsAction {
  final Map<DateTime, List> visiblePeriods;

  UpdateVisiblePeriodsAction(
    this.visiblePeriods,
  );
}

class ResetSelectPeriodViewModelAction {}

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

class LoadedPeriodTilesAction {
  final List<ExpandablePeriodTile> periodTiles;

  LoadedPeriodTilesAction(this.periodTiles);
}

class UpdateFilteredPeriodTilesAction {
  final List<ExpandablePeriodTile> periodTiles;

  UpdateFilteredPeriodTilesAction(this.periodTiles);
}

class LoadPeriodTilesAction {
  BuildContext context;
  DateTime day;

  LoadPeriodTilesAction(
    this.context,
    this.day,
   );
}
