import 'package:appoint/actions/appointments_action.dart';
import 'package:appoint/view_models/appointments_vm.dart';
import 'package:redux/redux.dart';

final appointmentsReducer = combineReducers<AppointmentsViewModel>([

  TypedReducer<AppointmentsViewModel, LoadedAppointmentsAction>(
      _setLoadedAppointments),
  TypedReducer<AppointmentsViewModel, UpdateAppointmentsIsLoadingAction>(_updateIsLoading),
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