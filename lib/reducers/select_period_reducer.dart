import 'package:appoint/actions/select_period_action.dart';
import 'package:appoint/utils/parse.dart';
import 'package:appoint/view_models/select_period_vm.dart';
import 'package:redux/redux.dart';

final selectPeriodReudcer = combineReducers<SelectedPeriodViewModel>([
  TypedReducer<SelectedPeriodViewModel, UpdateIsLoadingAction>(
      _updateIsLoading),
  TypedReducer<SelectedPeriodViewModel, LoadedPeriodsAction>(_loadedPeriods),
  TypedReducer<SelectedPeriodViewModel, UpdateTimeFilterAction>(
      _updateTimeFilter),
  TypedReducer<SelectedPeriodViewModel, UpdateVisibilityFilterAction>(
      _updateVisiblityFilter),
  TypedReducer<SelectedPeriodViewModel, UpdateSelectedDayAction>(
      _updateSelectedDay),
  TypedReducer<SelectedPeriodViewModel, ResetSelectPeriodViewModelAction>(
      _resetSelectPeriodViewModel),
]);

SelectedPeriodViewModel _resetSelectPeriodViewModel(
    SelectedPeriodViewModel vm, ResetSelectPeriodViewModelAction action) {
  return SelectedPeriodViewModel(
    periods: {},
    isLoading: false,
    timeFilter: null,
    visibleFirstDay: DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day + 1),
    visibleLastDay: Parse.lastDayOfMonth(DateTime.now()),
    selectedDay:
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
  );
}

SelectedPeriodViewModel _updateVisiblityFilter(
    SelectedPeriodViewModel vm, UpdateVisibilityFilterAction action) {
  return SelectedPeriodViewModel(
    periods: vm.periods,
    isLoading: vm.isLoading,
    timeFilter: vm.timeFilter,
    visibleFirstDay: action.visibleFirstDay,
    visibleLastDay: action.visibleLastDay,
    selectedDay: vm.selectedDay,
  );
}

SelectedPeriodViewModel _updateSelectedDay(
    SelectedPeriodViewModel vm, UpdateSelectedDayAction action) {
  return SelectedPeriodViewModel(
    periods: vm.periods,
    isLoading: vm.isLoading,
    timeFilter: vm.timeFilter,
    visibleFirstDay: vm.visibleFirstDay,
    visibleLastDay: vm.visibleLastDay,
    selectedDay: action.day,
  );
}

SelectedPeriodViewModel _updateTimeFilter(
    SelectedPeriodViewModel vm, UpdateTimeFilterAction action) {
  return SelectedPeriodViewModel(
    periods: vm.periods,
    isLoading: vm.isLoading,
    timeFilter: action.timeFilter,
    visibleFirstDay: vm.visibleFirstDay,
    visibleLastDay: vm.visibleLastDay,
    selectedDay: vm.selectedDay,
  );
}

SelectedPeriodViewModel _updateIsLoading(
    SelectedPeriodViewModel vm, UpdateIsLoadingAction action) {
  return SelectedPeriodViewModel(
    isLoading: action.isLoading,
    periods: vm.periods,
    visibleFirstDay: vm.visibleFirstDay,
    visibleLastDay: vm.visibleLastDay,
    timeFilter: vm.timeFilter,
    selectedDay: vm.selectedDay,
  );
}

SelectedPeriodViewModel _loadedPeriods(
    SelectedPeriodViewModel vm, LoadedPeriodsAction action) {
      vm.periods.addAll(action.periods);
  return SelectedPeriodViewModel(
    isLoading: vm.isLoading,
    periods: vm.periods,
    visibleFirstDay: vm.visibleFirstDay,
    visibleLastDay: vm.visibleLastDay,
    timeFilter: vm.timeFilter,
    selectedDay: vm.selectedDay,
  );
}
