import 'package:appoint/models/period.dart';
import 'package:appoint/widgets/expandable_period_tile.dart';
import 'package:flutter/material.dart';

class SelectedPeriodViewModel {
  ///all periods of this month or more
  final Map<DateTime, List<Period>> periods;
  ///currently shown periods for `selectedDay`
  final Map<DateTime, List> visiblePeriods;


  final bool isLoading;
  final TimeOfDay timeFilter;
  final DateTime visibleFirstDay;
  final DateTime visibleLastDay;
  final DateTime selectedDay;

  ///builded periodTiles with conflicts shown. Comparing `visiblePeriods` with `eventsOnDay`
  final List<ExpandablePeriodTile> periodTiles;
  ///subsequence of `periodTiles`filtered by timeFilter
  final List<ExpandablePeriodTile> filteredPeriodTiles;

  const SelectedPeriodViewModel({
    this.periods,
    this.visiblePeriods,
    this.isLoading,
    this.timeFilter,
    this.filteredPeriodTiles,
    this.visibleFirstDay,
    this.visibleLastDay,
    this.selectedDay,
    this.periodTiles,
  });
}
