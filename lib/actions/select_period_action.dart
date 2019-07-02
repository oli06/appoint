import 'package:appoint/model/period.dart';

class UpdateModeAction {
  final PeriodMode mode;

  UpdateModeAction(this.mode);
}

class UpdateSelectedValueAction {
  final DateTime value;

  UpdateSelectedValueAction(this.value);
}

class SetLoadedPeriodsAction {
  final List<Period> periods;

  SetLoadedPeriodsAction(this.periods);
}

class LoadPeriodsAction {
  final String companyId; 

  LoadPeriodsAction(this.companyId);
}