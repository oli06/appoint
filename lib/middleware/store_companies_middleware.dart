import 'package:appoint/actions/companies_action.dart';
import 'package:appoint/actions/select_period_action.dart';
import 'package:appoint/data/services.dart';
import 'package:appoint/model/app_state.dart';
import 'package:appoint/utils/parse.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createStoreCompaniesMiddleware() {
  final Service service = Service();

  final loadCompanies = _createLoadCompanies(service);
  final loadDatePeriods = _createLoadDatePeriods(service);
  final loadTimePeriods = _createLoadTimePeriods(service);

  return [
    TypedMiddleware<AppState, LoadCompaniesAction>(loadCompanies),
    TypedMiddleware<AppState, LoadDatePeriodsAction>(loadDatePeriods),
    TypedMiddleware<AppState, LoadTimePeriodsAction>(loadTimePeriods)
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

Middleware<AppState> _createLoadDatePeriods(Service service) {
  return (Store<AppState> store, action, next) {
    final act = action as LoadDatePeriodsAction;
    service
        .getDatePeriods(
      act.companyId,
      Parse.convertDateToPeriodDate(act.date),
    )
        .then((periods) {
      store.dispatch(SetLoadedPeriodsAction(periods));
    });

    next(action);
  };
}

Middleware<AppState> _createLoadTimePeriods(Service service) {
  return (Store<AppState> store, action, next) {
    final act = action as LoadTimePeriodsAction;
    service
        .getTimePeriods(
      act.companyId,
      Parse.convertTimeOfDay(act.time),
    )
        .then((periods) {
      store.dispatch(SetLoadedPeriodsAction(periods),);
    });

    next(action);
  };
}
