import 'package:appoint/actions/select_period_action.dart';
import 'package:appoint/model/app_state.dart';
import 'package:appoint/model/period.dart';
import 'package:appoint/model/select_period_vm.dart';
import 'package:appoint/selectors/selectors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class PeriodList extends StatefulWidget {
  final int companyId;
  final Widget Function(BuildContext context, int index, Period)
      itemBuilder;

  PeriodList({@required this.itemBuilder, @required this.companyId});

  @override
  _PeriodListState createState() => _PeriodListState();
}

class _PeriodListState extends State<PeriodList> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel.fromState(store),
      onInit: (store) => {
            if (store.state.selectPeriodViewModel.periodModel.mode ==
                SelectedPeriodMode.DATE)
              store.dispatch(
                LoadPeriodsAction(
                  widget.companyId,
                ),
              ),
          },
      builder: (context, vm) {
        if (vm.isLoading) {
          return _buildLoading();
        } else if (vm.periods.length == 0) {
          return _buildEmptyList();
        } else
          return _buildPeriodList(vm);
      },
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          SizedBox(
            height: 15,
          ),
          Text(
            "Zeiten werden geladen...",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w200,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildEmptyList() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Keine freie Zeiten gefunden. Versuchen Sie es mit einer anderen Zeit.",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w200),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodList(_ViewModel vm) {
    List<Period> periodsFiltered = filteredPeriodsSelector(vm.periods, vm.filter);
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: periodsFiltered.length,
        itemBuilder: (context, index) {
          return widget.itemBuilder(context, index, periodsFiltered[index]);
        },
      ),
    );
  }
}

class _ViewModel {
  final List<Period> periods;
  final SelectedPeriodMode mode;
  final bool isLoading;
  final List<bool> filter;

  _ViewModel({this.periods, this.mode, this.isLoading, this.filter});

  static _ViewModel fromState(Store<AppState> store) {
    return _ViewModel(
      periods: store.state.selectPeriodViewModel.periods,
      mode: store.state.selectPeriodViewModel.periodModel.mode,
      isLoading: store.state.selectPeriodViewModel.isLoading,
      filter: store.state.selectPeriodViewModel.filter,
    );
  }
}
