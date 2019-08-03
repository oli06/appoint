import 'package:appoint/actions/select_period_action.dart';
import 'package:appoint/models/app_state.dart';
import 'package:appoint/selectors/selectors.dart';
import 'package:appoint/utils/calendar.dart';
import 'package:appoint/utils/constants.dart';
import 'package:appoint/utils/parse.dart';
import 'package:appoint/view_models/select_period_vm.dart';
import 'package:appoint/view_models/settings_vm.dart';
import 'package:appoint/widgets/appoint_calendar.dart';
import 'package:appoint/widgets/dialog.dart' as appoint;
import 'package:appoint/widgets/expandable_period_tile.dart';
import 'package:appoint/widgets/navBar.dart';
import 'package:appoint/widgets/period_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:table_calendar/table_calendar.dart';

class SelectPeriod extends StatefulWidget {
  final int companyId;
  final Calendar calendar = Calendar();

  SelectPeriod({@required this.companyId});

  @override
  _SelectPeriodState createState() => _SelectPeriodState();
}

class _SelectPeriodState extends State<SelectPeriod> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      onInit: (store) {
        store.dispatch(LoadPeriodsAction(
            widget.companyId,
            DateTime(DateTime.now().year, DateTime.now().month,
                DateTime.now().day + 1),
            Parse.lastDayOfMonth(DateTime.now())));
      },
      builder: (context, vm) {
        return Scaffold(
          appBar: _buildNavBar(vm),
          body: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: <Widget>[
                  _buildSelectTimeRow(vm, context),
                  _buildDivider(),
                  _buildCalendar(context, vm),
                  _buildDivider(),
                  arePeriodsAvailable(vm.selectPeriodViewModel,
                          vm.selectPeriodViewModel.selectedDay)
                      ? _buildPeriodList(vm)
                      : Center(
                          child: Text(
                            "Keine freien Termine gefunden",
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Padding _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Divider(),
    );
  }

  Padding _buildSelectTimeRow(_ViewModel vm, BuildContext context) {
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
                    Text(_buildTimeOfDayButtonText(vm)),
                    Icon(Icons.timer),
                  ],
                ),
                onPressed: () => _selectTimeFilter(vm),
              ),
            ),
          ),
          IconButton(
            icon: Icon(CupertinoIcons.clear, size: 32),
            padding: EdgeInsets.zero,
            onPressed: () {
              if (vm.selectPeriodViewModel.timeFilter == null) {
                return;
              }
              vm.updateTimeFilter(null);
            },
          ),
        ],
      ),
    );
  }

  String _buildTimeOfDayButtonText(_ViewModel vm) {
    if (vm.selectPeriodViewModel.timeFilter == null) {
      return "nach Uhrzeit filtern";
    } else {
      return "${vm.selectPeriodViewModel.timeFilter.format(context)} | ändern";
    }
  }

  Widget _buildCalendar(BuildContext context, _ViewModel vm) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        AppointCalendar(
          visibleEvents: getVisibleDaysPeriodsList(vm.selectPeriodViewModel),
          context: context,
          onDaySelected: (DateTime day, List events) {
            print("update day selected to: ${day.day}");
            final dt = DateTime(day.year, day.month, day.day);
            vm.updateSelectedDay(dt);
          },
          onVisibleDaysChanged:
              (DateTime first, DateTime last, CalendarFormat format) {
            print("called visible days changed");
            vm.updateVisibilityFilter(first, last);

            vm.loadPeriods(widget.companyId, first, last);
          },
        ),
        if (vm.selectPeriodViewModel.isLoading) CupertinoActivityIndicator(),
      ],
    );
  }

  Future<List<Widget>> _buildPeriodTiles(_ViewModel vm) async {
    if (vm.settingsViewModel.settings[kSettingsCalendarIntegration] == null ||
        !vm.settingsViewModel.settings[kSettingsCalendarIntegration]) {
      print("no calendar integration");
      List<PeriodTile> _periods = [];

      final todaysPeriods = getVisibleDaysPeriodsList(
          vm.selectPeriodViewModel)[vm.selectPeriodViewModel.selectedDay];
      if (todaysPeriods != null) {
        todaysPeriods.forEach((period) {
          _periods.add(PeriodTile(
            period: period,
            onTap: () {
              vm.resetViewModel();
              Navigator.pop(context, period);
            },
          ));
        });
      }

      return _periods;
    } else {
      final result = await widget.calendar.retrieveCalendarEvents(
          vm.settingsViewModel.settings[kSettingsCalendarId],
          vm.selectPeriodViewModel.selectedDay);
      List<Widget> _periods = [];
      final todaysPeriods = getVisibleDaysPeriodsList(
          vm.selectPeriodViewModel)[vm.selectPeriodViewModel.selectedDay];
      if (todaysPeriods != null && result != null) {
        //if calendarId is invalid --> user deleted calendar, result is null //TODO: message
        todaysPeriods.forEach((period) {
          final eventConflicts = result.data.where((event) {
            if (event.start.isBefore(period.start) &&
                !event.end.isBefore(period.start)) {
              return true;
            }
            if (!event.start.isBefore(period.start) &&
                event.start.isBefore(period.start.add(period.duration))) {
              return true;
            }
            return false;
          }).toList();
          print("event conflicts are: ${eventConflicts.length}");

          _periods.add(ExpandablePeriodTile(
            period: period,
            onTap: () {
              vm.resetViewModel();
              Navigator.pop(context, period);
            },
            trailing: eventConflicts.length != 0 ? Icon(Icons.warning) : null,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Konflikte mit folgenden Terminen:",
                      style: TextStyle(fontSize: 16),
                    ),
                    ...eventConflicts
                        .map((event) => Text(
                            "${event.title}, ${Parse.hoursWithMinutes.format(event.start)} - ${Parse.hoursWithMinutes.format(event.end)}"))
                        .toList(),
                    CupertinoButton(
                      child: Text("Trotzdem wählen"),
                      onPressed: () {
                        vm.resetViewModel();
                        Navigator.pop(context, period);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ));
        });
      }

      print("returning calculated data now, with leght: ${_periods.length}");
      return _periods;
    }
  }

  Widget _buildPeriodList(_ViewModel vm) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: _buildPeriodTiles(vm),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done &&
                !snapshot.hasError) {
              return CupertinoScrollbar(
                child: ListView.separated(
                    itemCount: snapshot.data.length,
                    separatorBuilder: (context, index) => Divider(height: 1),
                    itemBuilder: (context, index) {
                      return snapshot.data[index];
                    }),
              );
            } else {
              return Column(
                children: <Widget>[
                  Center(child: CupertinoActivityIndicator()),
                  Text(
                    "freie Zeiten werden geladen",
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  void _selectTimeFilter(_ViewModel vm) {
    final DateTime maxDate = DateTime(2099, 12, 31, 23, 59, 59);
    DateTime minDate = DateTime.now();
    DateTime initialDate = DateTime(
        minDate.year,
        minDate.month,
        minDate.day + 1,
        vm.selectPeriodViewModel?.timeFilter?.hour ?? 08,
        vm.selectPeriodViewModel?.timeFilter?.minute ?? 00);
    minDate = DateTime(minDate.year, minDate.month, minDate.day, 0, 0, 0);

    if (Theme.of(context).platform == TargetPlatform.iOS) {
      DatePicker.showDatePicker(
        context,
        dateFormat: "HH:mm",
        minuteDivider: 15,
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

  NavBar _buildNavBar(_ViewModel vm) {
    return NavBar(
      "Neuer Termin",
      height: 59,
      leadingWidget: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () {
            vm.resetViewModel();
            Navigator.pop(context);
          }),
      secondHeader: "Zeitraum wählen",
      trailing: IconButton(
        color: Theme.of(context).primaryColor,
        icon: Icon(
          Icons.info_outline,
        ),
        onPressed: () {
          showCupertinoDialog(
            context: context,
            builder: (context) => appoint.Dialog(
              title: "Hilfe",
              information: "TODO: fill", //TODO: fill
              userActionWidget: CupertinoButton(
                child: Text("Alles klar!"),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ViewModel {
  final Function(DateTime selectedDay) updateSelectedDay;
  final SelectedPeriodViewModel selectPeriodViewModel;
  final SettingsViewModel settingsViewModel;
  final Function(DateTime visibleFirstDay, DateTime visibleLastDay)
      updateVisibilityFilter;
  final Function(TimeOfDay timeFilter) updateTimeFilter;
  final Function(int companyId, DateTime first, DateTime last) loadPeriods;
  final Function resetViewModel;

  _ViewModel({
    @required this.selectPeriodViewModel,
    this.updateTimeFilter,
    this.settingsViewModel,
    this.updateVisibilityFilter,
    this.updateSelectedDay,
    this.resetViewModel,
    this.loadPeriods,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      selectPeriodViewModel: store.state.selectPeriodViewModel,
      updateTimeFilter: (timeFilter) =>
          store.dispatch(UpdateTimeFilterAction(timeFilter)),
      updateVisibilityFilter: (first, last) =>
          store.dispatch(UpdateVisibilityFilterAction(first, last)),
      updateSelectedDay: (day) => store.dispatch(UpdateSelectedDayAction(day)),
      resetViewModel: () => store.dispatch(ResetSelectPeriodViewModelAction()),
      settingsViewModel: store.state.settingsViewModel,
      loadPeriods: (int companyId, DateTime first, DateTime last) =>
          store.dispatch(LoadPeriodsAction(companyId, first, last)),
    );
  }
}
