import 'package:appoint/actions/add_appoint_action.dart';
import 'package:redux/redux.dart';
import 'package:appoint/view_models/add_appoint_vm.dart';

final addAppointReducer = combineReducers<AddAppointViewModel>([
  TypedReducer<AddAppointViewModel, UpdatePeriodAction>(_updatePeriod),
  TypedReducer<AddAppointViewModel, UpdateCompanyAction>(_updateCompany),
  TypedReducer<AddAppointViewModel, UpdateTitleAction>(_updateTitle),
  TypedReducer<AddAppointViewModel, UpdateDescriptionAction>(
      _updateDescription),
]);

AddAppointViewModel _updatePeriod(
    AddAppointViewModel vm, UpdatePeriodAction action) {
  return AddAppointViewModel(
    company: vm.company,
    description: vm.description,
    period: action.period,
    title: vm.title,
  );
}

AddAppointViewModel _updateCompany(
    AddAppointViewModel vm, UpdateCompanyAction action) {
  return AddAppointViewModel(
    company: action.company,
    description: vm.description,
    period: vm.period,
    title: vm.title,
  );
}

AddAppointViewModel _updateTitle(
    AddAppointViewModel vm, UpdateTitleAction action) {
  return AddAppointViewModel(
    company: vm.company,
    description: vm.description,
    period: vm.period,
    title: action.title,
  );
}

AddAppointViewModel _updateDescription(
    AddAppointViewModel vm, UpdateDescriptionAction action) {
  return AddAppointViewModel(
    company: vm.company,
    description: action.description,
    period: vm.period,
    title: vm.title,
  );
}
