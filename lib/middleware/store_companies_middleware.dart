import 'package:appoint/actions/appointments_action.dart';
import 'package:appoint/actions/companies_action.dart';
import 'package:appoint/actions/select_period_action.dart';
import 'package:appoint/data/api.dart';
import 'package:appoint/models/app_state.dart';
import 'package:appoint/view_models/select_period_vm.dart';
import 'package:appoint/utils/parse.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createStoreCompaniesMiddleware() {
  final Api api = Api();

  final loadCompanies = _createLoadCompanies(api);
  final loadPeriods = _createLoadPeriods(api);
  final loadAppointments = _createLoadAppointments(api);

  return [
    TypedMiddleware<AppState, LoadCompaniesAction>(loadCompanies),
    TypedMiddleware<AppState, LoadPeriodsAction>(loadPeriods),
    TypedMiddleware<AppState, LoadAppointmentsAction>(loadAppointments)
  ];
}

Middleware<AppState> _createLoadCompanies(Api service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    store.dispatch(UpdateCompanyIsLoadingAction(true));

    service.getCompanies().then((companies) {
      store.dispatch(LoadedCompaniesAction(companies));
      store.dispatch(UpdateCompanyIsLoadingAction(false));
    });

    next(action);
  };
}

Middleware<AppState> _createLoadAppointments(Api service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    store.dispatch(UpdateAppointmentsIsLoadingAction(true));

    service.getAppointments().then((appointments) {
      store.dispatch(LoadedAppointmentsAction(appointments));
      store.dispatch(UpdateAppointmentsIsLoadingAction(false));
    });

    next(action);
  };
}

Middleware<AppState> _createLoadPeriods(Api service) {
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
