import 'package:appoint/actions/companies_action.dart';
import 'package:appoint/models/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class CompanyRangeSlider extends StatelessWidget {
  const CompanyRangeSlider({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      distinct: true,
      converter: (store) => _ViewModel.fromState(store),
      builder: (context, vm) {
        print("companyRangeSlider build");

        return Row(
          children: <Widget>[
            Slider(
              activeColor: Color(0xff09c199),
              value: vm.range,
              min: 1.0,
              max: 50.0,
              onChanged: (double newValue) =>
                  vm.companyFilterRangeAction(newValue),
            ),
            Text("${vm.range.toInt()} km"),
          ],
        );
      },
    );
  }
}

class _ViewModel {
  final void Function(double rangeFilter) companyFilterRangeAction;
  final double range;

  _ViewModel({
    this.range,
    this.companyFilterRangeAction,
  });

  static _ViewModel fromState(Store<AppState> store) {
    return _ViewModel(
      companyFilterRangeAction: (range) =>
          store.dispatch(CompanyFilterRangeAction(range)),
      range: store.state.selectCompanyViewModel.rangeFilter,
    );
  }

    @override
  int get hashCode => range.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel &&
          runtimeType == other.runtimeType &&
          range == other.range;
}
