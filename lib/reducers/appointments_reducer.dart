import 'package:appoint/actions/appointments_action.dart';
import 'package:appoint/view_models/appointments_vm.dart';
import 'package:redux/redux.dart';

final appointmentsReducer = combineReducers<AppointmentsViewModel>([
  TypedReducer<AppointmentsViewModel, LoadedAppointmentsAction>(
      _setLoadedAppointments),
  TypedReducer<AppointmentsViewModel, UpdateAppointmentsIsLoadingAction>(
      _updateIsLoading),
  TypedReducer<AppointmentsViewModel, CreateOrUpdateAppointAction>(_createOrUpdateAppoint),
]);

AppointmentsViewModel _setLoadedAppointments(
    AppointmentsViewModel vm, LoadedAppointmentsAction action) {
  return AppointmentsViewModel(
    isLoading: vm.isLoading,
    appointments: action.appointments,
  );
}

AppointmentsViewModel _updateIsLoading(
    AppointmentsViewModel vm, UpdateAppointmentsIsLoadingAction action) {
  return AppointmentsViewModel(
    isLoading: action.isLoading,
    appointments: vm.appointments,
  );
}

AppointmentsViewModel _createOrUpdateAppoint(
    AppointmentsViewModel vm, CreateOrUpdateAppointAction action) {
  if (action.appoint.id != null) {
    final index = vm.appointments
        .indexOf(vm.appointments.firstWhere((a) => a.id == action.appoint.id));
    vm.appointments[index] = action.appoint;
  } else {
    action.appoint.id = vm.appointments.length;
    vm.appointments.add(action.appoint);
  }
  return AppointmentsViewModel(
    isLoading: vm.isLoading,
    appointments: vm.appointments,
  );
}
