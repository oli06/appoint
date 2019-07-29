import 'package:appoint/models/appoint.dart';

class LoadAppointmentsAction {
  final String userId;

  LoadAppointmentsAction(this.userId);
}

class UpdateAppointmentsIsLoadingAction {
  final bool isLoading;

  UpdateAppointmentsIsLoadingAction(this.isLoading);
}

class LoadedAppointmentsAction {
  final List<Appoint> appointments;

  LoadedAppointmentsAction(this.appointments);
}

class AddAppointmentAction {
  final Appoint appoint;

  AddAppointmentAction(this.appoint);
}