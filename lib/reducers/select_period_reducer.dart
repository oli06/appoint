import 'package:appoint/actions/select_period_action.dart';
import 'package:redux/redux.dart';
import 'package:appoint/model/select_period_vm.dart';

final selectPeriodReudcer = combineReducers<SelectPeriodViewModel>([
  TypedReducer<SelectPeriodViewModel, UpdateModeAction>(_updateMode),
  TypedReducer<SelectPeriodViewModel, UpdateSelectedValueAction>(
      _updateSelectedValue),
  TypedReducer<SelectPeriodViewModel, SetLoadedPeriodsAction>(
      _setLoadedPeriods),
]);

SelectPeriodViewModel _updateMode(
    SelectPeriodViewModel vm, UpdateModeAction action) {
  return SelectPeriodViewModel(
    periods: vm.periods,
    periodModel: PeriodMode(
      mode: action.mode,
      value: action.value,
    ),
  );
}

SelectPeriodViewModel _setLoadedPeriods(
    SelectPeriodViewModel vm, SetLoadedPeriodsAction action) {
  return SelectPeriodViewModel(
    periodModel: vm.periodModel,
    periods: action.periods,
  );
}

SelectPeriodViewModel _updateSelectedValue(
    SelectPeriodViewModel vm, UpdateSelectedValueAction action) {
  return SelectPeriodViewModel(
    periods: vm.periods,
    periodModel: PeriodMode(mode: vm.periodModel.mode, value: action.value)
  );
}

