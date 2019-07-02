import 'package:appoint/actions/select_period_action.dart';
import 'package:redux/redux.dart';
import 'package:appoint/model/select_period_vm.dart';

final selectPeriodReudcer = combineReducers<SelectPeriodViewModel>([
  TypedReducer<SelectPeriodViewModel, UpdateModeAction>(_updateMode),
    TypedReducer<SelectPeriodViewModel, UpdateSelectedValueAction>(_updateSelectedValue),
  TypedReducer<SelectPeriodViewModel, SetLoadedPeriodsAction>(_setLoadedPeriods),
]);

SelectPeriodViewModel _updateMode(SelectPeriodViewModel vm, UpdateModeAction action) {
  return SelectPeriodViewModel(
    mode: action.mode,
    periods: vm.periods,
    selectedValue: vm.selectedValue
  );
}

SelectPeriodViewModel _setLoadedPeriods(SelectPeriodViewModel vm, SetLoadedPeriodsAction action) {
    return SelectPeriodViewModel(
    mode: vm.mode,
    periods: action.periods,
    selectedValue: vm.selectedValue
  );
}

SelectPeriodViewModel _updateSelectedValue(SelectPeriodViewModel vm, UpdateSelectedValueAction action) {
  return   SelectPeriodViewModel(
    mode: vm.mode,
    periods: vm.periods,
    selectedValue: action.value
  );
}