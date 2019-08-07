import 'package:appoint/models/appoint.dart';

class AppointmentsViewModel {
  final List<Appoint> appointments;
  final bool isLoading;

  const AppointmentsViewModel({
    this.appointments,
    this.isLoading,
  });

  @override
  int get hashCode => appointments.hashCode ^ isLoading.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppointmentsViewModel &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          appointments == other.appointments;
}
