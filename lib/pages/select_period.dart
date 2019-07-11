import 'package:appoint/actions/select_period_action.dart';
import 'package:appoint/models/app_state.dart';
import 'package:appoint/view_models/select_period_vm.dart';
import 'package:appoint/utils/parse.dart';
import 'package:appoint/widgets/dialog.dart' as prefix0;
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:appoint/widgets/navBar.dart';
import 'package:appoint/widgets/period_list.dart';
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
      onInit: (store) =>  store.dispatch(UpdateSelectedValueAction(store.state.selectPeriodViewModel.periodModel.mode == SelectedPeriodMode.DATE ?
            DateTime.now() : TimeOfDay(hour: 8, minute: 0),
          )), //inital date-value
      builder: (context, vm) {
        return Scaffold(
          appBar: _buildNavBar(vm),
          body: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
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
                    padding: const EdgeInsets.only(left: 16.0, right: 16),
                    child: Divider(),
                  ),
                  WeekdaysRow(),
                  Expanded(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 8.0, right: 8, top: 8),
                      child: PeriodList(
                        companyId: widget.companyId,
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

  String _buildSelectedValueButtonText(_ViewModel vm, BuildContext context) {
    dynamic selectedValue =
        vm.selectPeriodViewModel.periodModel.getSelectedValue();

    if (vm.selectPeriodViewModel.periodModel.mode == SelectedPeriodMode.DATE) {
      if (selectedValue != null) {
        var dateString = Parse.dateOnly.format((selectedValue as DateTime));
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
    final DateTime maxDate = DateTime(2022, 12, 31, 23, 59, 59);
    DateTime minDate = DateTime.now();
    DateTime initialDate;
    if (vm.selectPeriodViewModel.periodModel.mode == SelectedPeriodMode.DATE) {
      initialDate =
          vm.selectPeriodViewModel.periodModel.getSelectedValue() != null
              ? vm.selectPeriodViewModel.periodModel.getSelectedValue()
              : minDate.add(Duration(days: 1));
    } else {
      initialDate =
          DateTime(minDate.year, minDate.month, minDate.day + 1, 08, 00);
      minDate = DateTime(minDate.year, minDate.month, minDate.day, 0, 0, 0);
    }

    if (Theme.of(context).platform == TargetPlatform.iOS) {
      DatePicker.showDatePicker(
        context,
        dateFormat:
            vm.selectPeriodViewModel.periodModel.mode == SelectedPeriodMode.DATE
                ? "dd-MMMM-yyyy"
                : "HH:mm",
        onConfirm: (value, _) {
          if (vm.selectPeriodViewModel.periodModel.mode ==
              SelectedPeriodMode.TIME) {
            //PlatformSpecificDatePicker returned auch im timeModus ein Datum anstelle eines TimeOfDay Objc
            vm.updateSelectedValue(TimeOfDay.fromDateTime(value));
            vm.loadPeriods(widget.companyId);
            return;
          }

          vm.updateSelectedValue(value);
          vm.loadPeriods(widget.companyId);
        },
        pickerMode:
            vm.selectPeriodViewModel.periodModel.mode == SelectedPeriodMode.DATE
                ? DateTimePickerMode.date
                : DateTimePickerMode.time,
        initialDateTime: initialDate,
        maxDateTime: maxDate,
        minDateTime: minDate,
        pickerTheme: DateTimePickerTheme(
            cancel: Text(
              "Abbrechen",
            ),
            confirm: Text(
              "Auswählen",
              style: TextStyle(color: Color(0xff1991eb)),
            )),
      );
    } else {
      if (vm.selectPeriodViewModel.periodModel.mode ==
          SelectedPeriodMode.DATE) {
        showDatePicker(
          context: context,
          firstDate: minDate,
          lastDate: DateTime(2022),
          initialDate: initialDate,
          selectableDayPredicate: (date) {
            if (date.weekday == DateTime.sunday) {
              return false;
            } else {
              return true;
            }
          },
        ).then((value) {
          vm.updateSelectedValue(value);
          vm.loadPeriods(widget.companyId);
        });
      } else {
        showTimePicker(
          context: context,
          initialTime: TimeOfDay(
            hour: TimeOfDay.now().hourOfPeriod,
            minute: 0,
          ),
        ).then((value) {
          vm.updateSelectedValue(value);
          vm.loadPeriods(widget.companyId);
        });
      }
    }
  }

  NavBar _buildNavBar(_ViewModel vm) {
    return NavBar(
      "Neuer Termin",
      height: 59,
      leadingWidget: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () => Navigator.pop(context)),
      secondHeader: "Zeitraum wählen",
      trailing: IconButton(
        icon: Icon(
          Icons.info_outline,
        ),
        onPressed: () {
          showCupertinoDialog(
          context: context, builder: (context) => prefix0.Dialog(
            title: "Hilfe",
            information: "Um einen Termin vereinbaren zu können, muss zuerst ein freier Zeitraum bei dem sowohl das Unternehmen, als auch Sie Zeit haben. Die angezeigten Zeiträume entsprechen bereits den freien Zeiträumen des jeweiligen Unternehmens. \n Damit Ihnen die Suche nicht so schwer fällt haben Sie verschiedene Möglichkeiten. \n \t 1. Ein bestimmtes Datum wählen, um freie Zeiten an diesem Tag anzeigen zu lassen \n \t 2. Auf den Uhrzeit-Modus umschalten, um Tage anzuzeigen, an denen das Unternehmen beispielsweise um 17:00 Uhr Zeit hat \n \n Außerdem können Sie einzelne Wochentage ausschließen, sodass von diesem Wochentag keine freie Zeiten angezeigt werden.",
          userActionWidget: CupertinoButton(child: Text("Alles klar!"), onPressed: () => Navigator.pop(context),),
          ),
          );
        },
      ),
    );
  }
}

class _ViewModel {
  final SelectedPeriodViewModel selectPeriodViewModel;

  final Function setMode;
  final Function(dynamic value) updateSelectedValue;
  final Function(int companyId) loadPeriods;

  _ViewModel({
    @required this.selectPeriodViewModel,
    this.setMode,
    this.updateSelectedValue,
    this.loadPeriods,
  });

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
      },
    );
  }
}
