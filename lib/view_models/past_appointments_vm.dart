import 'package:appoint/models/appoint.dart';

class PastAppointmentsViewModel {
  final List<Appoint> appointments;
  final bool isLoading;

  const PastAppointmentsViewModel({
    this.appointments,
    this.isLoading,
  });

  @override
  int get hashCode => appointments.hashCode ^ isLoading.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PastAppointmentsViewModel &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          appointments == other.appointments;
}
