import 'package:appoint/actions/select_period_action.dart' as periodFilter;
import 'package:appoint/models/app_state.dart';
import 'package:appoint/widgets/day_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class WeekdaysRow extends StatefulWidget {
  @override
  _WeekdaysRowState createState() => _WeekdaysRowState();
}

class _WeekdaysRowState extends State<WeekdaysRow> {
  final List<DayButtonData> items = [
    DayButtonData(text: "MO"),
    DayButtonData(text: "DI"),
    DayButtonData(text: "MI"),
    DayButtonData(text: "DO"),
    DayButtonData(text: "FR"),
    DayButtonData(text: "SA"),
    DayButtonData(text: "SO"),
  ];

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel.fromState(store),
      builder: (context, vm) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: items
              .map(
                (x) => new DayButton(
                      text: x.text,
                      onTap: () {
                        if (x.toggleEnabled(items)) {
                          vm.updateFilter(DayButtonData.getFilterList(items));
                        }
                      },
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 1.5,
                              color: x.isEnabled
                                  ? Color(0xff09c199)
                                  : Color(0xff6e7885)),
                          borderRadius: BorderRadius.circular(5),
                          color: x.isEnabled ? null : Color(0xff6e7885)),
                    ),
              )
              .toList()),
    );
  }
}

class DayButtonData {
  final String text;
  bool _isEnabled = true;
  bool get isEnabled => _isEnabled;

  DayButtonData({
    this.text,
  });

  bool toggleEnabled(List<DayButtonData> buttons) {
    if (_isEnabled) {
      if (canBeDisabled(buttons)) {
        _isEnabled = !_isEnabled;
        return true;
      }
    } else {
      _isEnabled = !_isEnabled;
      return true;
    }

    return false;
  }

  static bool canBeDisabled(List<DayButtonData> buttons) {
    return buttons.where((x) => !x._isEnabled).length != buttons.length - 1;
  }

  static List<bool> getFilterList(List<DayButtonData> buttons) {
    return buttons.map((b) => b.isEnabled).toList();
  }
}

class _ViewModel {
  final List<bool> filter;
  final Function updateFilter;

  _ViewModel({this.filter, this.updateFilter});

  static _ViewModel fromState(Store<AppState> store) {
    return _ViewModel(
      filter: store.state.selectPeriodViewModel.filter,
      updateFilter: (List<bool> filter) => store.dispatch(
            periodFilter.UpdateFilterAction(filter),
          ),
    );
  }
}
