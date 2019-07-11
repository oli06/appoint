import 'package:appoint/actions/select_period_action.dart';
import 'package:appoint/view_models/select_period_vm.dart';
import 'package:redux/redux.dart';

final selectPeriodReudcer = combineReducers<SelectedPeriodViewModel>([
  TypedReducer<SelectedPeriodViewModel, UpdateModeAction>(_updateMode),
  TypedReducer<SelectedPeriodViewModel, UpdateSelectedValueAction>(
      _updateSelectedValue),
  TypedReducer<SelectedPeriodViewModel, SetLoadedPeriodsAction>(
      _setLoadedPeriods),
  TypedReducer<SelectedPeriodViewModel, UpdateIsLoadingAction>(_updateIsLoading),
  TypedReducer<SelectedPeriodViewModel, UpdateFilterAction>(_updateFilter),
]);

SelectedPeriodViewModel _updateMode(
    SelectedPeriodViewModel vm, UpdateModeAction action) {
  return SelectedPeriodViewModel(
    periods: vm.periods,
    isLoading: vm.isLoading,
    filter: vm.filter,
    periodModel: PeriodMode(
        mode: action.mode,
        date: vm.periodModel.date,
        time: vm.periodModel.time),
  );
}

SelectedPeriodViewModel _setLoadedPeriods(
    SelectedPeriodViewModel vm, SetLoadedPeriodsAction action) {
  return SelectedPeriodViewModel(
    periodModel: vm.periodModel,
    periods: action.periods,
    isLoading: vm.isLoading,
    filter: vm.filter,
  );
}

SelectedPeriodViewModel _updateIsLoading(
    SelectedPeriodViewModel vm, UpdateIsLoadingAction action) {
  return SelectedPeriodViewModel(
      isLoading: action.isLoading,
      periodModel: vm.periodModel,
      filter: vm.filter,
      periods: vm.periods);
}

SelectedPeriodViewModel _updateSelectedValue(
    SelectedPeriodViewModel vm, UpdateSelectedValueAction action) {
  return SelectedPeriodViewModel(
      periods: vm.periods,
      filter: vm.filter,
      isLoading: vm.isLoading,
      periodModel: vm.periodModel.mode == SelectedPeriodMode.DATE
          ? PeriodMode(
              mode: vm.periodModel.mode,
              date: action.value,
              time: vm.periodModel.time)
          : PeriodMode(
              mode: vm.periodModel.mode,
              date: vm.periodModel.date,
              time: action.value));
}

SelectedPeriodViewModel _updateFilter(
    SelectedPeriodViewModel vm, UpdateFilterAction action) {
  return SelectedPeriodViewModel(
      periods: vm.periods,
      filter: action.filter,
      isLoading: vm.isLoading,
      periodModel: vm.periodModel);
}