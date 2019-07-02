import 'package:appoint/actions/companies_action.dart';
import 'package:appoint/actions/select_period_action.dart';
import 'package:appoint/data/services.dart';
import 'package:appoint/model/app_state.dart';
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
    service.getPeriods(action.companyId).then((periods) {
      store.dispatch(SetLoadedPeriodsAction(periods));
    });

    next(action);
  };
}