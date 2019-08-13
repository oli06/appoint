import 'package:appoint/models/appoint.dart';

class LoadPastAppointments {}

class LoadedPastAppointmentsAction {
  final List<Appoint> appointments;

  LoadedPastAppointmentsAction(this.appointments);
}

class UpdatePastAppointmentsIsLoadingAction {
  final bool isLoading;

  UpdatePastAppointmentsIsLoadingAction(this.isLoading);
}
