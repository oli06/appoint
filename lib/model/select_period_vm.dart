import 'package:appoint/model/period.dart';

class SelectPeriodViewModel {
  final List<Period> periods;
  final PeriodMode mode;
  final DateTime selectedValue;

  const SelectPeriodViewModel({this.periods, this.mode, this.selectedValue});
}