import 'package:appoint/actions/select_period_action.dart';
import 'package:appoint/model/app_state.dart';
import 'package:appoint/model/select_period_vm.dart';
import 'package:appoint/widgets/day_button.dart';
import 'package:appoint/widgets/navBar.dart';
import 'package:appoint/widgets/weekdays_row.dart';
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
      builder: (context, vm) {
        return Scaffold(
          body: SafeArea(
            child: Column(
              children: <Widget>[
                _buildNavBar(context),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: vm.selectPeriodViewModel.periodModel.mode ==
                          SelectedPeriodMode.DATE
                      ? WeekdaysRow()
                      : Container(
                          child: Text(
                            vm.selectPeriodViewModel.periodModel
                                .getSelectedValue()
                                .toString(),
                          ),
                        ),
                ),
                vm.selectPeriodViewModel.periodModel.mode == SelectedPeriodMode.DATE
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
