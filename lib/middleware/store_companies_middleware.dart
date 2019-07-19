import 'package:appoint/actions/appointments_action.dart';
import 'package:appoint/actions/companies_action.dart';
import 'package:appoint/actions/favorites_action.dart';
import 'package:appoint/actions/select_period_action.dart';
import 'package:appoint/actions/user_action.dart';
import 'package:appoint/data/api.dart';
import 'package:appoint/models/app_state.dart';
import 'package:appoint/selectors/selectors.dart';
import 'package:appoint/view_models/select_period_vm.dart';
import 'package:appoint/utils/parse.dart';
import 'package:redux/redux.dart';
import 'package:location/location.dart';

List<Middleware<AppState>> createStoreCompaniesMiddleware() {
  final Api api = Api();

  final loadCompanies = _createLoadCompanies(api);
  final loadPeriods = _createLoadPeriods(api);
  final loadAppointments = _createLoadAppointments(api);
  final loadUser = _createLoadUser(api);
  final verifyUser = _createUserVerifcation(api);
  final loadUserLocation = _createLoadUserLocation();
  final loadUserFavorites = _createLoadUserFavorites(api);
  final removeUserFavorites = _createRemoveFromUserFavorites(api);
  final addUserFavorite = _createAddToUserFavorites(api);
  final signUpNewUser = _createRegisterUser(api);

  return [
    TypedMiddleware<AppState, LoadCompaniesAction>(loadCompanies),
    TypedMiddleware<AppState, LoadPeriodsAction>(loadPeriods),
    TypedMiddleware<AppState, LoadAppointmentsAction>(loadAppointments),
    TypedMiddleware<AppState, LoadUserAction>(loadUser),
    TypedMiddleware<AppState, VerifyUserAction>(verifyUser),
    TypedMiddleware<AppState, LoadUserLocationAction>(loadUserLocation),
    TypedMiddleware<AppState, LoadFavoritesAction>(loadUserFavorites),
    TypedMiddleware<AppState, RemoveFromUserFavoritesAction>(removeUserFavorites),
    TypedMiddleware<AppState, AddToUserFavoritesAction>(addUserFavorite),
    TypedMiddleware<AppState, RegisterUserAction>(signUpNewUser),
  ];
}

Middleware<AppState> _createLoadCompanies(Api api) {
  return (Store<AppState> store, action, NextDispatcher next) {
    store.dispatch(UpdateCompanyIsLoadingAction(true));

    api.getCompanies().then((companies) {
      store.dispatch(LoadedCompaniesAction(companies));
      store.dispatch(UpdateCompanyIsLoadingAction(false));
    });

    next(action);
  };
}

Middleware<AppState> _createLoadAppointments(Api api) {
  return (Store<AppState> store, action, NextDispatcher next) {
    store.dispatch(UpdateAppointmentsIsLoadingAction(true));

    api.getAppointments().then((appointments) {
      store.dispatch(LoadedAppointmentsAction(appointments));
      store.dispatch(UpdateAppointmentsIsLoadingAction(false));
    });

    next(action);
  };
}

Middleware<AppState> _createRegisterUser(Api api) {
  return (Store<AppState> store, action, NextDispatcher next) {

    api.registerUser(action.user).then((result) {
      if(result) {
        print("created user with success");
      } else {
        print("failed user registration");
      }
    });

    next(action);
  };
}

Middleware<AppState> _createLoadPeriods(Api api) {
  return (Store<AppState> store, action, next) {
    store.dispatch(UpdateIsLoadingAction(true));

    api.getPeriodsForMonth(action.companyId).then((periodMap) {
      store.dispatch(SetLoadedPeriodsAction(periodMap));
      store.dispatch(UpdateVisiblePeriodsAction(getVisibleDaysPeriodsList(store.state.selectPeriodViewModel.periods, store.state.selectPeriodViewModel.visibleFirstDay, store.state.selectPeriodViewModel.visibleLastDay)));
      store.dispatch(UpdateIsLoadingAction(false));
    });

    /* if (store.state.selectPeriodViewModel.periodModel.mode ==
        SelectedPeriodMode.DATE) {
      final date = store.state.selectPeriodViewModel.periodModel.date;
      print(
          "loading for date: ${date.toIso8601String()}, company: ${action.companyId}");
      api
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
      print(
          "loading for time: ${time.toString()}, company: ${action.companyId}");
      api
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
    } */

    next(action);
  };
}

Middleware<AppState> _createUserVerifcation(Api api) {
  return (Store<AppState> store, action, next) {
    store.dispatch(UpdateUserLoadingAction(true));

    api
        .postUserVerificationCode(action.userId, action.verificationCode)
        .then((result) {
      store.dispatch(VerifyUserResultAction(result));
      store.dispatch(UpdateUserLoadingAction(false));
    });

    next(action);
  };
}

Middleware<AppState> _createLoadUser(Api api) {
  return (Store<AppState> store, action, next) {
    store.dispatch(UpdateUserLoadingAction(true));

    api.getUser().then((user) {
      store.dispatch(LoadedUserAction(user));
      store.dispatch(UpdateUserLoadingAction(false));
    });

    next(action);
  };
}

Middleware<AppState> _createLoadUserLocation() {
  return (Store<AppState> store, action, next) {
    final locator = Location();
    locator
        .getLocation()
        .then((pos) => store.dispatch(LoadedUserLocationAction(pos)));

    next(action);
  };
}

Middleware<AppState> _createLoadUserFavorites(Api api) {
  return (Store<AppState> store, action, next) {
    if (action.favoriteIds.length == 0) {
      store.dispatch(LoadedFavoritesAction([]));
    } else {
      store.dispatch(UpdateIsLoadingFavoritesAction(true));
      api.getUserFavorites(action.favoriteIds).then((result) {
        store.dispatch(LoadedFavoritesAction(result));
        store.dispatch(UpdateIsLoadingFavoritesAction(false));
      });
    }

    next(action);
  };
}

Middleware<AppState> _createRemoveFromUserFavorites(Api api) {
  return (Store<AppState> store, action, next) {
    api.removeUserFavorites(action.userId, action.companyIds).then((res) {
      //TODO: use user.favorites stream to reload them 
    });
    
    next(action);
  };
}

Middleware<AppState> _createAddToUserFavorites(Api api) {
  return (Store<AppState> store, action, next) {
    api.addUserFavorite(action.userId, action.companyId).then((res) {
      //TODO: use user.favorites stream to reload them 
    });
    
    next(action);
  };
}
