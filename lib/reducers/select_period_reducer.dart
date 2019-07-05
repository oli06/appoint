import 'package:appoint/actions/select_period_action.dart';
import 'package:appoint/view_models/select_period_vm.dart';
import 'package:redux/redux.dart';

final selectPeriodReudcer = combineReducers<SelectPeriodViewModel>([
  TypedReducer<SelectPeriodViewModel, UpdateModeAction>(_updateMode),
  TypedReducer<SelectPeriodViewModel, UpdateSelectedValueAction>(
      _updateSelectedValue),
  TypedReducer<SelectPeriodViewModel, SetLoadedPeriodsAction>(
      _setLoadedPeriods),
  TypedReducer<SelectPeriodViewModel, UpdateIsLoadingAction>(_updateIsLoading),
  TypedReducer<SelectPeriodViewModel, UpdateFilterAction>(_updateFilter),
]);

SelectPeriodViewModel _updateMode(
    SelectPeriodViewModel vm, UpdateModeAction action) {
  return SelectPeriodViewModel(
    periods: vm.periods,
    isLoading: vm.isLoading,
    filter: vm.filter,
    periodModel: PeriodMode(
        mode: action.mode,
        date: vm.periodModel.date,
        time: vm.periodModel.time),
  );
}

SelectPeriodViewModel _setLoadedPeriods(
    SelectPeriodViewModel vm, SetLoadedPeriodsAction action) {
  return SelectPeriodViewModel(
    periodModel: vm.periodModel,
    periods: action.periods,
    isLoading: vm.isLoading,
    filter: vm.filter,
  );
}

SelectPeriodViewModel _updateIsLoading(
    SelectPeriodViewModel vm, UpdateIsLoadingAction action) {
  return SelectPeriodViewModel(
      isLoading: action.isLoading,
      periodModel: vm.periodModel,
      filter: vm.filter,
      periods: vm.periods);
}

SelectPeriodViewModel _updateSelectedValue(
    SelectPeriodViewModel vm, UpdateSelectedValueAction action) {
  return SelectPeriodViewModel(
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

SelectPeriodViewModel _updateFilter(
    SelectPeriodViewModel vm, UpdateFilterAction action) {
  return SelectPeriodViewModel(
      periods: vm.periods,
      filter: action.filter,
      isLoading: vm.isLoading,
      periodModel: vm.periodModel);
}
