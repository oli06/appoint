import 'package:appoint/actions/select_period_action.dart';
import 'package:appoint/models/app_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class PeriodTimeButton extends StatelessWidget {
  const PeriodTimeButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      distinct: true,
      converter: (store) => _ViewModel.fromState(store),
      builder: (context, vm) {
        print("PeriodTimeButton build");

        return Padding(
          padding: const EdgeInsets.only(top: 4.0, left: 8.0, right: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: OutlineButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(_buildTimeOfDayButtonText(vm.timeFilter, context)),
                        Icon(Icons.timer),
                      ],
                    ),
                    onPressed: () => _selectTimeFilter(vm, context),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(CupertinoIcons.clear, size: 32),
                padding: EdgeInsets.zero,
                onPressed: () {
                  if (vm.timeFilter == null) {
                    return;
                  }
                  vm.updateTimeFilter(null);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  String _buildTimeOfDayButtonText(TimeOfDay timeFilter, BuildContext context) {
    if (timeFilter == null) {
      return "nach Uhrzeit filtern";
    } else {
      return "${timeFilter.format(context)} | ändern";
    }
  }

  void _selectTimeFilter(_ViewModel vm, BuildContext context) {
    final DateTime maxDate = DateTime(2099, 12, 31, 23, 59, 59);
    DateTime minDate = DateTime.now();
    DateTime initialDate = DateTime(
      minDate.year,
      minDate.month,
      minDate.day + 1,
      vm?.timeFilter?.hour ?? 08,
      vm?.timeFilter?.minute ?? 00,
    );
    minDate = DateTime(minDate.year, minDate.month, minDate.day, 0, 0, 0);

    if (Theme.of(context).platform == TargetPlatform.iOS) {
      DatePicker.showDatePicker(
        context,
        dateFormat: "HH:mm",
        //minuteDivider: 15, //TODO: use correct github repo to support minuteDividers
        onConfirm: (value, _) {
          vm.updateTimeFilter(TimeOfDay.fromDateTime(value));
        },
        pickerMode: DateTimePickerMode.time,
        initialDateTime: initialDate,
        maxDateTime: maxDate,
        minDateTime: minDate,
        pickerTheme: DateTimePickerTheme(
          cancel: Text("Abbrechen"),
          confirm: Text(
            "Auswählen",
            style: TextStyle(
              color: Color(0xff1991eb),
            ),
          ),
        ),
      );
    } else {
      showTimePicker(
        context: context,
        initialTime: TimeOfDay(
          hour: TimeOfDay.now().hourOfPeriod,
          minute: 0,
        ),
      ).then((value) {
        vm.updateTimeFilter(value);
      });
    }
  }
}

class _ViewModel {
  final Function(TimeOfDay timeFilter) updateTimeFilter;
  final TimeOfDay timeFilter;

  _ViewModel({
    this.updateTimeFilter,
    this.timeFilter,
  });

  static _ViewModel fromState(Store<AppState> store) {
    return _ViewModel(
      updateTimeFilter: (timeFilter) =>
          store.dispatch(UpdateTimeFilterAction(timeFilter)),
      timeFilter: store.state.selectPeriodViewModel.timeFilter,
    );
  }

  @override
  int get hashCode => timeFilter.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel &&
          runtimeType == other.runtimeType &&
          timeFilter == other.timeFilter;
}
