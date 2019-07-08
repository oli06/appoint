import 'package:appoint/actions/select_period_action.dart';
import 'package:appoint/models/app_state.dart';
import 'package:appoint/models/day.dart';
import 'package:appoint/models/period.dart';
import 'package:appoint/view_models/select_period_vm.dart';
import 'package:appoint/selectors/selectors.dart';
import 'package:appoint/widgets/list_header.dart';
import 'package:appoint/widgets/period_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

class PeriodList extends StatefulWidget {
  final int companyId;

  PeriodList({@required this.companyId});

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
    final List<Day<Period>> days =
        groupPeriodsByDate(filteredPeriodsSelector(vm.periods, vm.filter));
    final List<Widget> slivers = List<Widget>();
    days.asMap().forEach((index, day) =>
        slivers.addAll(_buildHeaderBuilderLists(context, index, 1, day)));
    return CupertinoScrollbar(
        child: CustomScrollView(
      slivers: slivers,
    ));
  }

  List<Widget> _buildHeaderBuilderLists(
      BuildContext context, int firstIndex, int count, Day<Period> day) {
    return List.generate(count, (sliverIndex) {
      sliverIndex += firstIndex;
      return new SliverStickyHeaderBuilder(
        builder: (context, state) => AnimatedListHeader(
              state: state,
              start: day.date,
            ),
        sliver: new SliverList(
          delegate: new SliverChildBuilderDelegate(
            (context, i) => PeriodTile(
                  onTap: () {
                    Navigator.pop(context, day.events[i]);
                  },
                  period: day.events[i],
                ),
            childCount: day.events.length,
          ),
        ),
      );
    });
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
