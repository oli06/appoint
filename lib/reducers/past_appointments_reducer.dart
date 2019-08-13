import 'package:appoint/actions/past_appointments_action.dart';
import 'package:appoint/view_models/past_appointments_vm.dart';
import 'package:redux/redux.dart';

final pastAppointmentsReducer = combineReducers<PastAppointmentsViewModel>([
  TypedReducer<PastAppointmentsViewModel, LoadedPastAppointmentsAction>(
      _setLoadedAppointments),
  TypedReducer<PastAppointmentsViewModel,
      UpdatePastAppointmentsIsLoadingAction>(_updateIsLoading),
]);

PastAppointmentsViewModel _setLoadedAppointments(
    PastAppointmentsViewModel vm, LoadedPastAppointmentsAction action) {
  return PastAppointmentsViewModel(
    isLoading: vm.isLoading,
    appointments: action.appointments,
  );
}

PastAppointmentsViewModel _updateIsLoading(PastAppointmentsViewModel vm,
    UpdatePastAppointmentsIsLoadingAction action) {
  return PastAppointmentsViewModel(
    isLoading: action.isLoading,
    appointments: vm.appointments,
  );
}
