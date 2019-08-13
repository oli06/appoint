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

class CreateOrUpdateAppointAction {
  final Appoint appoint;

  CreateOrUpdateAppointAction(this.appoint);
}