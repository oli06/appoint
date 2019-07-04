import 'package:appoint/model/select_period_vm.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlatformSpecificDatePicker extends StatelessWidget {
  final Function(dynamic dateTime) onValueChanged;
  final DateTime initialDate;
  final int maximumYear;
  final DateTime minimalDate;
  final bool use24hFormat;
  final SelectedPeriodMode mode;

  final Function selectableDayPredicate;

  PlatformSpecificDatePicker(
      {@required this.onValueChanged,
      @required this.initialDate,
      @required this.maximumYear,
      @required this.minimalDate,
      @required this.mode,
      this.use24hFormat,
      this.selectableDayPredicate});

  @override
  Widget build(BuildContext context) {
    final bool isIos = Theme.of(context).platform == TargetPlatform.iOS;

    return isIos
        ? CupertinoDatePicker(
            mode: mode == SelectedPeriodMode.DATE
                ? CupertinoDatePickerMode.date
                : CupertinoDatePickerMode.time,
            onDateTimeChanged: (value) => onValueChanged(value),
            initialDateTime: initialDate,
            minimumYear: minimalDate.year,
            maximumYear: maximumYear,
            use24hFormat: use24hFormat == null ? false: use24hFormat,
          )
        : {
            if (mode == SelectedPeriodMode.DATE)
              {
                showDatePicker(
                  context: context,
                  firstDate: minimalDate,
                  lastDate: DateTime(maximumYear),
                  initialDate: initialDate,
                  selectableDayPredicate: selectableDayPredicate,
                ).then((value) => onValueChanged(value))
              }
            else
              {
                showTimePicker(
                  context: context,
                  initialTime: TimeOfDay(
                    hour: TimeOfDay.now().hourOfPeriod,
                    minute: 0,
                  ),
                ).then((value) => onValueChanged(value))
              }
          };
  }
}
