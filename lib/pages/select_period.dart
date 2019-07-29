import 'package:appoint/actions/select_period_action.dart';
import 'package:appoint/models/app_state.dart';
import 'package:appoint/selectors/selectors.dart';
import 'package:appoint/view_models/select_period_vm.dart';
import 'package:appoint/widgets/appoint_calendar.dart';
import 'package:appoint/widgets/dialog.dart' as appoint;
import 'package:appoint/widgets/expandable_period_tile.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:appoint/widgets/navBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:table_calendar/table_calendar.dart';

class SelectPeriod extends StatefulWidget {
  final int companyId;

  SelectPeriod({@required this.companyId});

  @override
  _SelectPeriodState createState() => _SelectPeriodState();
}

class _SelectPeriodState extends State<SelectPeriod> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      onInit: (store) {
        store.dispatch(
            LoadPeriodsAction(widget.companyId, DateTime.now().month));
        //initial selection is today --> load conflicts for today
        store.dispatch(LoadPeriodTilesAction(context, DateTime.now()));
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
                  vm.selectPeriodViewModel.visiblePeriods[
                              vm.selectPeriodViewModel.selectedDay] ==
                          null
                      ? Center(
                          child: Text(
                            "Keine freien Termine gefunden",
                            style: TextStyle(fontSize: 18),
                          ),
                        )
                      : _buildPeriodList(vm),
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
              vm.updateVisiblePeriods(
                getVisibleDaysPeriodsList(
                    vm.selectPeriodViewModel.periods,
                    vm.selectPeriodViewModel.visibleFirstDay,
                    vm.selectPeriodViewModel.visibleLastDay),
              );

              vm.updateFilteredPeriodTiles(
                  vm.selectPeriodViewModel.periodTiles);
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
    print("is loading?: ${vm.selectPeriodViewModel.isLoading}");

    return vm.selectPeriodViewModel.isLoading
        ? Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CupertinoActivityIndicator(),
                  Text("freie Termine werden geladen"),
                ],
              ),
            ),
          )
        : AppointCalendar(
            visibleEvents: vm.selectPeriodViewModel.visiblePeriods,
            context: context,
            onDaySelected: (DateTime day, List events) {
              print("update day selected to: ${day.day}");
              final dt = DateTime(day.year, day.month, day.day);
              vm.updateSelectedDay(dt);
              vm.loadPeriodTiles(context, dt);
            },
            onVisibleDaysChanged:
                (DateTime first, DateTime last, CalendarFormat format) {
              print("called visible days changed");
              vm.updateVisiblePeriods(filterDaysPeriodsList(
                  getVisibleDaysPeriodsList(
                      vm.selectPeriodViewModel.periods, first, last),
                  vm.selectPeriodViewModel.timeFilter));

              vm.updateVisibilityFilter(first, last);
            },
          );
  }

  Widget _buildPeriodList(_ViewModel vm) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: vm.selectPeriodViewModel.isLoading
            ? Column(
                children: <Widget>[
                  Center(child: CupertinoActivityIndicator()),
                ],
              )
            : CupertinoScrollbar(
                child: ListView.separated(
                  itemCount:
                      vm.selectPeriodViewModel.filteredPeriodTiles.length,
                  separatorBuilder: (context, index) => Divider(height: 1),
                  itemBuilder: (context, index) =>
                      vm.selectPeriodViewModel.filteredPeriodTiles[index],
                ),
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
          vm.updateVisiblePeriods(filterDaysPeriodsList(
              getVisibleDaysPeriodsList(
                vm.selectPeriodViewModel.periods,
                vm.selectPeriodViewModel.visibleFirstDay,
                vm.selectPeriodViewModel.visibleLastDay,
              ),
              TimeOfDay.fromDateTime(value)));

          vm.updateTimeFilter(TimeOfDay.fromDateTime(value));
          vm.updateFilteredPeriodTiles(filterPeriodTiles(
              vm.selectPeriodViewModel.periodTiles,
              TimeOfDay.fromDateTime(value)));
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
        vm.updateVisiblePeriods(filterDaysPeriodsList(
            getVisibleDaysPeriodsList(
              vm.selectPeriodViewModel.periods,
              vm.selectPeriodViewModel.visibleFirstDay,
              vm.selectPeriodViewModel.visibleLastDay,
            ),
            value));

        vm.updateTimeFilter(value);
        vm.updateFilteredPeriodTiles(
            filterPeriodTiles(vm.selectPeriodViewModel.periodTiles, value));
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
              information:
                  "Um einen Termin vereinbaren zu können, muss zuerst ein freier Zeitraum bei dem sowohl das Unternehmen, als auch Sie Zeit haben. Die angezeigten Zeiträume entsprechen bereits den freien Zeiträumen des jeweiligen Unternehmens. \n Damit Ihnen die Suche nicht so schwer fällt haben Sie verschiedene Möglichkeiten. \n \t 1. Ein bestimmtes Datum wählen, um freie Zeiten an diesem Tag anzeigen zu lassen \n \t 2. Auf den Uhrzeit-Modus umschalten, um Tage anzuzeigen, an denen das Unternehmen beispielsweise um 17:00 Uhr Zeit hat \n \n Außerdem können Sie einzelne Wochentage ausschließen, sodass von diesem Wochentag keine freie Zeiten angezeigt werden.",
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
  final Function(int companyId, int month) loadPeriods;
  final Function(Map<DateTime, List> periods) updateVisiblePeriods;
  final Function(DateTime visibleFirstDay, DateTime visibleLastDay)
      updateVisibilityFilter;
  final Function(TimeOfDay timeFilter) updateTimeFilter;

  final Function(bool isLoading) updateIsLoading;
  final Function(List<ExpandablePeriodTile> periodTiles) loadedPeriodTiles;
  final Function(BuildContext context, DateTime day) loadPeriodTiles;
  final Function resetViewModel;
  final Function(List<ExpandablePeriodTile> filteredPeriodTiles)
      updateFilteredPeriodTiles;

  _ViewModel({
    @required this.selectPeriodViewModel,
    this.updateTimeFilter,
    this.loadPeriods,
    this.updateVisiblePeriods,
    this.updateVisibilityFilter,
    this.updateSelectedDay,
    this.resetViewModel,
    this.loadedPeriodTiles,
    this.updateIsLoading,
    this.updateFilteredPeriodTiles,
    this.loadPeriodTiles,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      selectPeriodViewModel: store.state.selectPeriodViewModel,
      loadPeriods: (int companyId, int month) {
        store.dispatch(LoadPeriodsAction(companyId, month));
      },
      loadPeriodTiles: (context, day) =>
          store.dispatch(LoadPeriodTilesAction(context, day)),
      updateTimeFilter: (timeFilter) =>
          store.dispatch(UpdateTimeFilterAction(timeFilter)),
      updateVisiblePeriods: (map) {
        store.dispatch(UpdateVisiblePeriodsAction(map));
      },
      updateVisibilityFilter: (first, last) =>
          store.dispatch(UpdateVisibilityFilterAction(first, last)),
      updateSelectedDay: (day) => store.dispatch(UpdateSelectedDayAction(day)),
      updateIsLoading: (value) => store.dispatch(UpdateIsLoadingAction(value)),
      loadedPeriodTiles: (value) =>
          store.dispatch(LoadedPeriodTilesAction(value)),
      resetViewModel: () => store.dispatch(ResetSelectPeriodViewModelAction()),
      updateFilteredPeriodTiles: (periods) =>
          store.dispatch(UpdateFilteredPeriodTilesAction(periods)),
    );
  }
}
