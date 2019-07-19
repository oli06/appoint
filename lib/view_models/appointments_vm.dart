import 'package:appoint/models/appoint.dart';

class AppointmentsViewModel {
  final List<Appoint> appointments;
  final bool isLoading;

  const AppointmentsViewModel({this.appointments, this.isLoading});
}