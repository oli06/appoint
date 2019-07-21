import 'package:appoint/actions/select_period_action.dart';
import 'package:appoint/models/period.dart';
import 'package:appoint/utils/parse.dart';
import 'package:appoint/view_models/select_period_vm.dart';
import 'package:redux/redux.dart';

final selectPeriodReudcer = combineReducers<SelectedPeriodViewModel>([
  TypedReducer<SelectedPeriodViewModel, SetLoadedPeriodsAction>(
      _setLoadedPeriods),
  TypedReducer<SelectedPeriodViewModel, UpdateIsLoadingAction>(
      _updateIsLoading),
  TypedReducer<SelectedPeriodViewModel, UpdateVisiblePeriodsAction>(
      _updateVisiblePeriods),
  TypedReducer<SelectedPeriodViewModel, UpdateTimeFilterAction>(
      _updateTimeFilter),
  TypedReducer<SelectedPeriodViewModel, UpdateVisibilityFilterAction>(
      _updateVisiblityFilter),
  TypedReducer<SelectedPeriodViewModel, UpdateSelectedDayAction>(
      _updateSelectedDay),
  TypedReducer<SelectedPeriodViewModel, LoadedPeriodTilesAction>(
      _loadedPeriodTiles),
  TypedReducer<SelectedPeriodViewModel, ResetSelectPeriodViewModelAction>(
      _resetSelectPeriodViewModel),
  TypedReducer<SelectedPeriodViewModel, UpdateFilteredPeriodTilesAction>(
      _updateFilteredPeriodTiles),
]);

SelectedPeriodViewModel _updateVisiblePeriods(
    SelectedPeriodViewModel vm, UpdateVisiblePeriodsAction action) {
  return SelectedPeriodViewModel(
    periods: vm.periods,
    visiblePeriods: action.visiblePeriods,
    isLoading: vm.isLoading,
    timeFilter: vm.timeFilter,
    visibleFirstDay: vm.visibleFirstDay,
    visibleLastDay: vm.visibleLastDay,
    selectedDay: vm.selectedDay,
    periodTiles: vm.periodTiles,
    filteredPeriodTiles: vm.filteredPeriodTiles,
  );
}

SelectedPeriodViewModel _resetSelectPeriodViewModel(
    SelectedPeriodViewModel vm, ResetSelectPeriodViewModelAction action) {
  return SelectedPeriodViewModel(
    periods: {},
    visiblePeriods: {},
    isLoading: true,
    timeFilter: null,
    visibleFirstDay: null,
    visibleLastDay: null,
    selectedDay:
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
    periodTiles: [],
    filteredPeriodTiles: [],
  );
}

SelectedPeriodViewModel _updateVisiblityFilter(
    SelectedPeriodViewModel vm, UpdateVisibilityFilterAction action) {
  return SelectedPeriodViewModel(
    periods: vm.periods,
    visiblePeriods: vm.visiblePeriods,
    isLoading: vm.isLoading,
    timeFilter: vm.timeFilter,
    visibleFirstDay: action.visibleFirstDay,
    visibleLastDay: action.visibleLastDay,
    selectedDay: vm.selectedDay,
    filteredPeriodTiles: vm.filteredPeriodTiles,
    periodTiles: vm.periodTiles,
  );
}

SelectedPeriodViewModel _updateSelectedDay(
    SelectedPeriodViewModel vm, UpdateSelectedDayAction action) {
  return SelectedPeriodViewModel(
    periods: vm.periods,
    visiblePeriods: vm.visiblePeriods,
    isLoading: vm.isLoading,
    periodTiles: vm.periodTiles,
    timeFilter: vm.timeFilter,
    visibleFirstDay: vm.visibleFirstDay,
    visibleLastDay: vm.visibleLastDay,
    filteredPeriodTiles: vm.filteredPeriodTiles,
    selectedDay: action.day,
  );
}

SelectedPeriodViewModel _updateTimeFilter(
    SelectedPeriodViewModel vm, UpdateTimeFilterAction action) {
  return SelectedPeriodViewModel(
    periods: vm.periods,
    visiblePeriods: vm.visiblePeriods,
    isLoading: vm.isLoading,
    periodTiles: vm.periodTiles,
    timeFilter: action.timeFilter,
    visibleFirstDay: vm.visibleFirstDay,
    filteredPeriodTiles: vm.filteredPeriodTiles,
    visibleLastDay: vm.visibleLastDay,
    selectedDay: vm.selectedDay,
  );
}

SelectedPeriodViewModel _setLoadedPeriods(
    SelectedPeriodViewModel vm, SetLoadedPeriodsAction action) {
  Map<DateTime, List<Period>> days = {};
  action.periods.forEach((period) {
    final date = Parse.dateTimeToDateOnly(period.start);
    days.containsKey(date) ? days[date].add(period) : days[date] = [period];
  });

  vm.periods.addAll(days);
  return SelectedPeriodViewModel(
    periods: vm.periods,
    visiblePeriods: vm.visiblePeriods,
    isLoading: vm.isLoading,
    filteredPeriodTiles: vm.filteredPeriodTiles,
    timeFilter: vm.timeFilter,
    visibleFirstDay: vm.visibleFirstDay,
    periodTiles: vm.periodTiles,
    visibleLastDay: vm.visibleLastDay,
    selectedDay: vm.selectedDay,
  );
}

SelectedPeriodViewModel _updateIsLoading(
    SelectedPeriodViewModel vm, UpdateIsLoadingAction action) {
  return SelectedPeriodViewModel(
    isLoading: action.isLoading,
    visiblePeriods: vm.visiblePeriods,
    periods: vm.periods,
    visibleFirstDay: vm.visibleFirstDay,
    visibleLastDay: vm.visibleLastDay,
    filteredPeriodTiles: vm.filteredPeriodTiles,
    periodTiles: vm.periodTiles,
    timeFilter: vm.timeFilter,
    selectedDay: vm.selectedDay,
  );
}

SelectedPeriodViewModel _loadedPeriodTiles(
    SelectedPeriodViewModel vm, LoadedPeriodTilesAction action) {
  return SelectedPeriodViewModel(
    isLoading: vm.isLoading,
    visiblePeriods: vm.visiblePeriods,
    periods: vm.periods,
    visibleFirstDay: vm.visibleFirstDay,
    visibleLastDay: vm.visibleLastDay,
    filteredPeriodTiles: vm.filteredPeriodTiles,
    periodTiles: action.periodTiles,
    timeFilter: vm.timeFilter,
    selectedDay: vm.selectedDay,
  );
}

SelectedPeriodViewModel _updateFilteredPeriodTiles(
    SelectedPeriodViewModel vm, UpdateFilteredPeriodTilesAction action) {
  return SelectedPeriodViewModel(
    isLoading: vm.isLoading,
    visiblePeriods: vm.visiblePeriods,
    periods: vm.periods,
    visibleFirstDay: vm.visibleFirstDay,
    visibleLastDay: vm.visibleLastDay,
    filteredPeriodTiles: action.periodTiles,
    periodTiles: vm.periodTiles,
    timeFilter: vm.timeFilter,
    selectedDay: vm.selectedDay,
  );
}
