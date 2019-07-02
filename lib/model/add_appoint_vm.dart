import 'package:appoint/model/company.dart';
import 'package:appoint/model/period.dart';

class AddAppointViewModel {
  final String title;
  final String description;
  final Company company;
  final Period period; 

  const AddAppointViewModel({this.title, this.description, this.company, this.period});
}