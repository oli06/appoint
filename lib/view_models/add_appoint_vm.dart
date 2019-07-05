import 'package:appoint/models/company.dart';
import 'package:appoint/models/period.dart';

class AddAppointViewModel {
  final String title;
  final String description;
  final Company company;
  final Period period; 

  const AddAppointViewModel({this.title, this.description, this.company, this.period});
}