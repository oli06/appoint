import 'package:appoint/models/period.dart';
import 'package:appoint/view_models/select_period_vm.dart';

class UpdateModeAction {
  final SelectedPeriodMode mode;

  UpdateModeAction(this.mode);
}

class UpdateSelectedValueAction {
  final dynamic value;

  UpdateSelectedValueAction(this.value);
}

class UpdateFilterAction {
  final List<bool> filter;

  UpdateFilterAction(this.filter);
}

class SetLoadedPeriodsAction {
  final List<Period> periods;

  SetLoadedPeriodsAction(this.periods);
}

class UpdateIsLoadingAction {
  final bool isLoading;

  UpdateIsLoadingAction(this.isLoading);
}

class LoadPeriodsAction {
  final int companyId;

  LoadPeriodsAction(this.companyId);
}