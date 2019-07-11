import 'package:appoint/models/appoint.dart';
import 'package:appoint/models/company.dart';
import 'package:appoint/models/period.dart';

class UpdatePeriodAction {
  final Period period;

  UpdatePeriodAction(this.period);
}

class UpdateCompanyAction {
  final Company company;

  UpdateCompanyAction(this.company);
}

class UpdateTitleAction {
  final String title;

  UpdateTitleAction(this.title);
}

class UpdateDescriptionAction {
  final String description;

  UpdateDescriptionAction(this.description);
}

//TODO: is this required?
class CancelEditOrAddAppointAction {}
