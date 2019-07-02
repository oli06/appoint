import 'package:appoint/actions/select_period_action.dart';
import 'package:appoint/model/app_state.dart';
import 'package:appoint/model/period.dart';
import 'package:appoint/model/select_period_vm.dart';
import 'package:appoint/widgets/day_button.dart';
import 'package:appoint/widgets/navBar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class SelectPeriod extends StatefulWidget {
  final Period period;

  SelectPeriod({this.period});

  @override
  _SelectPeriodState createState() => _SelectPeriodState();
}

class _SelectPeriodState extends State<SelectPeriod> {
  String compId = "1"; //TODO in Store

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      onInit: (store) => store.dispatch(LoadPeriodsAction(compId)),
      builder: (context, vm) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: <Widget>[
                _buildNavBar(context),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: vm.selectPeriodViewModel.mode == PeriodMode.DATE
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            DayButton(
                              text: "MO",
                            ),
                            DayButton(
                              text: "DI",
                            ),
                            DayButton(
                              text: "MI",
                            ),
                            DayButton(
                              text: "DO",
                            ),
                            DayButton(
                              text: "FR",
                            ),
                            DayButton(
                              text: "SA",
                            ),
                          ],
                        )
                      : Container(
                          height: 0,
                          width: 0,
                        ),
                ),
                vm.selectPeriodViewModel.mode == PeriodMode.DATE
                    ? _buildPeriodSelect()
                    : _buildDateSelect(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: OutlineButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Datum"),
                Icon(Icons.event),
              ],
            ),
            //onPressed: () => _selectPeriod(context, true),
            onPressed: () {},
          ),
        ),
        Expanded(
          child: OutlineButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Uhrzeit"),
                Icon(Icons.watch_later),
              ],
            ),
            //onPressed: () => _selectPeriod(context, false),
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildPeriodSelect() {
    //date ausgewählt, also mögliche Uhrzeiten anzeigen
    return Container(
      height: 0,
    );
  }

  Widget _buildDateSelect() {
    //Uhrzeit ausgewählt; mögliche Tage anzeigen
    return Container(
      height: 0,
    );
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
      endingWidget: Container(
        height: 0,
      ),
      tabBar: _buildButtons(),
    );
  }
}

class _ViewModel {
  final SelectPeriodViewModel selectPeriodViewModel;

  _ViewModel({@required this.selectPeriodViewModel});

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(selectPeriodViewModel: store.state.selectPeriodViewModel);
  }
}
