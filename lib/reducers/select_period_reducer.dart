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
  TypedReducer<SelectedPeriodViewModel,
          UpdatePrioritizePrivateAppointmentsAction>(
      _updatePrioritizePrivateAppointments),
  TypedReducer<SelectedPeriodViewModel, UpdateTimeFilterAction>(
      _updateTimeFilter),
  TypedReducer<SelectedPeriodViewModel, UpdateVisibilityFilterAction>(
      _updateVisiblityFilter),
  TypedReducer<SelectedPeriodViewModel, UpdateSelectedDayAction>(
      _updateSelectedDay),
]);

SelectedPeriodViewModel _updateVisiblePeriods(
    SelectedPeriodViewModel vm, UpdateVisiblePeriodsAction action) {
  return SelectedPeriodViewModel(
    periods: vm.periods,
    visiblePeriods: action.visiblePeriods,
    isLoading: vm.isLoading,
    prioritizePrivateAppointments: vm.prioritizePrivateAppointments,
    timeFilter: vm.timeFilter,
    visibleFirstDay: vm.visibleFirstDay,
    visibleLastDay: vm.visibleLastDay,
    selectedDay: vm.selectedDay,
  );
}

SelectedPeriodViewModel _updateVisiblityFilter(
    SelectedPeriodViewModel vm, UpdateVisibilityFilterAction action) {
  return SelectedPeriodViewModel(
    periods: vm.periods,
    visiblePeriods: vm.visiblePeriods,
    isLoading: vm.isLoading,
    prioritizePrivateAppointments: vm.prioritizePrivateAppointments,
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
    visiblePeriods: vm.visiblePeriods,
    isLoading: vm.isLoading,
    prioritizePrivateAppointments: vm.prioritizePrivateAppointments,
    timeFilter: vm.timeFilter,
    visibleFirstDay: vm.visibleFirstDay,
    visibleLastDay: vm.visibleLastDay,
    selectedDay: action.day,
  );
}

SelectedPeriodViewModel _updatePrioritizePrivateAppointments(
    SelectedPeriodViewModel vm,
    UpdatePrioritizePrivateAppointmentsAction action) {
  return SelectedPeriodViewModel(
    periods: vm.periods,
    visiblePeriods: vm.visiblePeriods,
    isLoading: vm.isLoading,
    prioritizePrivateAppointments: action.prioritizePrivate,
    timeFilter: vm.timeFilter,
    visibleFirstDay: vm.visibleFirstDay,
    visibleLastDay: vm.visibleLastDay,
    selectedDay: vm.selectedDay,
  );
}

SelectedPeriodViewModel _updateTimeFilter(
    SelectedPeriodViewModel vm, UpdateTimeFilterAction action) {
  return SelectedPeriodViewModel(
    periods: vm.periods,
    visiblePeriods: vm.visiblePeriods,
    isLoading: vm.isLoading,
    prioritizePrivateAppointments: vm.prioritizePrivateAppointments,
    timeFilter: action.timeFilter,
    visibleFirstDay: vm.visibleFirstDay,
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

  //action.periods.forEach((period) => vm.periods.putIfAbsent(period.start, () => [period]));
  vm.periods.addAll(days);
  return SelectedPeriodViewModel(
    periods: vm.periods,
    visiblePeriods: vm.visiblePeriods,
    isLoading: vm.isLoading,
    prioritizePrivateAppointments: vm.prioritizePrivateAppointments,
    timeFilter: vm.timeFilter,
    visibleFirstDay: vm.visibleFirstDay,
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
    timeFilter: vm.timeFilter,
    prioritizePrivateAppointments: vm.prioritizePrivateAppointments,
    selectedDay: vm.selectedDay,
  );
}
