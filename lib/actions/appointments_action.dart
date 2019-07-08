import 'package:appoint/models/appoint.dart';

class LoadAppointmentsAction {}

class UpdateAppointmentsIsLoadingAction {
  final bool isLoading;

  UpdateAppointmentsIsLoadingAction(this.isLoading);
}

class LoadedAppointmentsAction {
  final List<Appoint> appointments;

  LoadedAppointmentsAction(this.appointments);
}