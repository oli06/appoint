import 'package:appoint/model/period.dart';
import 'package:appoint/model/select_period_vm.dart';
import 'package:flutter/material.dart';

class UpdateModeAction {
  final SelectedPeriodMode mode;
  final dynamic value;

  UpdateModeAction(this.mode, this.value);
}

class UpdateSelectedValueAction {
  final dynamic value;

  UpdateSelectedValueAction(this.value);
}

class SetLoadedPeriodsAction {
  final List<Period> periods;

  SetLoadedPeriodsAction(this.periods);
}

class LoadDatePeriodsAction {
  final int companyId; 
  final DateTime date;

  LoadDatePeriodsAction(this.companyId, this.date);
}

class LoadTimePeriodsAction {
  final int companyId;
  final TimeOfDay time;

  LoadTimePeriodsAction(this.companyId, this.time);
}