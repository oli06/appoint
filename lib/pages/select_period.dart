import 'package:appoint/actions/select_period_action.dart';
import 'package:appoint/models/app_state.dart';
import 'package:appoint/models/period.dart';
import 'package:appoint/view_models/select_period_vm.dart';
import 'package:appoint/utils/parse.dart';
import 'package:appoint/widgets/bottom_picker.dart';
import 'package:appoint/widgets/date_picker.dart';
import 'package:appoint/widgets/navBar.dart';
import 'package:appoint/widgets/period_list.dart';
import 'package:appoint/widgets/period_tile.dart';
import 'package:appoint/widgets/switch.dart';
import 'package:appoint/widgets/weekdays_row.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class SelectPeriod extends StatefulWidget {
  final int companyId;

  SelectPeriod({@required this.companyId});

  @override
  _SelectPeriodState createState() => _SelectPeriodState();
}

class _SelectPeriodState extends State<SelectPeriod> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      onInit: (store) => store.dispatch(UpdateSelectedValueAction(
            DateTime.now(),
          )), //inital date-value
      builder: (context, vm) {
        return Scaffold(
          body: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  _buildNavBar(context),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.only(left: 8, right: 8),
                            child: OutlineButton(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(_buildSelectedValueButtonText(
                                      vm, context)),
                                  Icon(
                                    vm.selectPeriodViewModel.periodModel.mode ==
                                            SelectedPeriodMode.DATE
                                        ? Icons.date_range
                                        : Icons.timer,
                                  ),
                                ],
                              ),
                              onPressed: () => _selectValueClicked(vm, context),
                            ),
                          ),
                        ),
                        PlatformSpecificSwitch(
                            value: vm.selectPeriodViewModel.periodModel.mode ==
                                SelectedPeriodMode.DATE,
                            onChanged: (value) {
                              vm.setMode(value
                                  ? SelectedPeriodMode.DATE
                                  : SelectedPeriodMode.TIME);
                              vm.loadPeriods(widget.companyId);
                            }),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 16.0, right: 16, bottom: 8),
                    child: Divider(),
                  ),
                  _buildWeekdays(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: PeriodList(
                        companyId: widget.companyId,
                        itemBuilder: (context, index, Period period) =>
                            _buildPeriodTile(
                                period,
                                vm.selectPeriodViewModel.periodModel.mode,
                                context),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  DateTime _lastDay;

  bool _isFirstElementOfDay(Period period) {
    if (_lastDay == null) {
      _lastDay = period.start;
      return true;
    } else if (_lastDay.year == period.start.year &&
        _lastDay.month == period.start.month &&
        _lastDay.day == period.start.day) {
      return false;
    } else {
      _lastDay = period.start;
      return true;
    }
  }

  Widget _buildPeriodTile(
      Period period, SelectedPeriodMode mode, BuildContext context) {
    Function onTap = () {
      Navigator.pop(context, period);
    };

    if (mode == SelectedPeriodMode.DATE) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _isFirstElementOfDay(period)
              ? Container(
                  height: 30,
                  color: Colors.grey[350],
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      Parse.dateWithWeekday.format(period.start.toUtc()),
                    ),
                  ),
                )
              : Divider(
                  height: 1,
                ),
          PeriodTile(
            onTap: onTap,
            period: period,
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            height: 30,
            color: Colors.grey[350],
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                Parse.dateWithWeekday.format(period.start),
              ),
            ),
          ),
          PeriodTile(
            onTap: onTap,
            period: period,
          ),
        ],
      );
    }
  }

  String _buildSelectedValueButtonText(_ViewModel vm, BuildContext context) {
    dynamic selectedValue =
        vm.selectPeriodViewModel.periodModel.getSelectedValue();

    if (vm.selectPeriodViewModel.periodModel.mode == SelectedPeriodMode.DATE) {
      if (selectedValue != null) {
        var dateString =
            Parse.dateOnly.format((selectedValue as DateTime));
        return "$dateString | ändern";
      }

      return "Datum auswählen";
    } else {
      if (selectedValue != null) {
        return "${(selectedValue as TimeOfDay).format(context)} | ändern";
      }

      return "Uhrzeit auswählen";
    }
  }

  void _selectValueClicked(_ViewModel vm, BuildContext context) {
    final DateTime minDate = DateTime.now().add(Duration(days: 1));
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return BottomPicker(
          picker: PlatformSpecificDatePicker(
            initialDate: minDate,
            maximumYear: 2100,
            use24hFormat: true,
            minimalDate: minDate,
            selectableDayPredicate: (date) {
              if (date.weekday == DateTime.sunday) {
                return false;
              } else {
                return true;
              }
            },
            mode: vm.selectPeriodViewModel.periodModel.mode,
            onValueChanged: (value) {
              if (vm.selectPeriodViewModel.periodModel.mode ==
                  SelectedPeriodMode.TIME) {
                if (value is DateTime) {
                  //PlatformSpecificDatePicker returned auch im timeModus ein Datum anstelle eines TimeOfDay Objc
                  value = TimeOfDay.fromDateTime(value);
                }
              }
              vm.updateSelectedValue(value);
              vm.loadPeriods(widget.companyId);
            },
          ),
        );
      },
    );
  }

  Widget _buildWeekdays() {
    return WeekdaysRow();
  }

  NavBar _buildNavBar(BuildContext context) {
    return NavBar(
      "Neuer Termin",
      leadingWidget: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      secondHeader: "Zeitraum wählen",
      endingWidget: IconButton(
        icon: Icon(
          Icons.info_outline,
        ),
        onPressed: () {
          //TODO show page info
        },
      ),
    );
  }
}

class _ViewModel {
  final SelectPeriodViewModel selectPeriodViewModel;

  final Function setMode;
  final Function(dynamic value) updateSelectedValue;
  final Function(int companyId) loadPeriods;

  _ViewModel(
      {@required this.selectPeriodViewModel,
      this.setMode,
      this.updateSelectedValue,
      this.loadPeriods});

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
        selectPeriodViewModel: store.state.selectPeriodViewModel,
        setMode: (SelectedPeriodMode newMode) {
          store.dispatch(UpdateModeAction(newMode));
        },
        updateSelectedValue: (dynamic value) {
          store.dispatch(UpdateSelectedValueAction(value));
        },
        loadPeriods: (int companyId) {
          store.dispatch(LoadPeriodsAction(companyId));
        });
  }
}
