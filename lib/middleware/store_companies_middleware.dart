import 'package:appoint/actions/companies_action.dart';
import 'package:appoint/actions/select_period_action.dart';
import 'package:appoint/data/services.dart';
import 'package:appoint/model/app_state.dart';
import 'package:appoint/model/select_period_vm.dart';
import 'package:appoint/utils/parse.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createStoreCompaniesMiddleware() {
  final Service service = Service();

  final loadCompanies = _createLoadCompanies(service);
  final loadPeriods = _createLoadPeriods(service);

  return [
    TypedMiddleware<AppState, LoadCompaniesAction>(loadCompanies),
    TypedMiddleware<AppState, LoadPeriodsAction>(loadPeriods)
  ];
}

Middleware<AppState> _createLoadCompanies(Service service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    service.getCompanies().then((companies) {
      store.dispatch(LoadedCompaniesAction(companies));
    });

    next(action);
  };
}

Middleware<AppState> _createLoadPeriods(Service service) {
  return (Store<AppState> store, action, next) {
    store.dispatch(UpdateIsLoadingAction(true));

    if (store.state.selectPeriodViewModel.periodModel.mode ==
        SelectedPeriodMode.DATE) {
      final date = store.state.selectPeriodViewModel.periodModel.date;
      print("loading for date: ${date.toIso8601String()}");
      service
          .getDatePeriods(
        action.companyId,
        Parse.convertDateToPeriodDate(
            store.state.selectPeriodViewModel.periodModel.date),
      )
          .then((periods) {
        store.dispatch(SetLoadedPeriodsAction(periods));
        store.dispatch(UpdateIsLoadingAction(false));
      });
    } else {
      final time = store.state.selectPeriodViewModel.periodModel.time;
      print("loading for time: ${time.toString()}");
      service
          .getTimePeriods(
        action.companyId,
        Parse.convertTimeOfDay(time),
      )
          .then((periods) {
        store.dispatch(
          SetLoadedPeriodsAction(periods),
        );
        store.dispatch(UpdateIsLoadingAction(false));
      });
    }

    next(action);
  };
}