import 'package:appoint/actions/appointments_action.dart';
import 'package:appoint/actions/companies_action.dart';
import 'package:appoint/actions/favorites_action.dart';
import 'package:appoint/actions/select_period_action.dart';
import 'package:appoint/actions/settings_action.dart';
import 'package:appoint/actions/user_action.dart';
import 'package:appoint/data/api.dart';
import 'package:appoint/models/app_state.dart';
import 'package:appoint/models/category.dart';
import 'package:appoint/selectors/selectors.dart';
import 'package:appoint/utils/constants.dart';
import 'package:redux/redux.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<Middleware<AppState>> createStoreCompaniesMiddleware() {
  final Api api = Api();

  final loadCompanies = _createLoadCompanies(api);
  final loadAppointments = _createLoadAppointments(api);
  final verifyUser = _createUserVerifcation(api);
  final loadUserLocation = _createLoadUserLocation();
  final loadUserFavorites = _createLoadUserFavorites(api);
  final removeUserFavorites = _createRemoveFromUserFavorites(api);
  final addUserFavorite = _createAddToUserFavorites(api);
  final loadSharedPreferences = _createLoadSharedPreferences();
  final loadCategories = _createLoadCategories(api);

  final authenticate = _authenticate(api);
  final loginProcessDone = _loadedUserConfigurationAction();
  final loadPeriods = _createLoadPeriods(api);

  return [
    TypedMiddleware<AppState, LoadCompaniesAction>(loadCompanies),
    TypedMiddleware<AppState, LoadAppointmentsAction>(loadAppointments),
    TypedMiddleware<AppState, VerifyUserAction>(verifyUser),
    TypedMiddleware<AppState, LoadUserLocationAction>(loadUserLocation),
    TypedMiddleware<AppState, LoadFavoritesAction>(loadUserFavorites),
    TypedMiddleware<AppState, RemoveFromUserFavoritesAction>(
        removeUserFavorites),
    TypedMiddleware<AppState, AddToUserFavoritesAction>(addUserFavorite),
    TypedMiddleware<AppState, LoadSharedPreferencesAction>(
        loadSharedPreferences),
    TypedMiddleware<AppState, LoadCategoriesAction>(loadCategories),
    TypedMiddleware<AppState, AuthenticateAction>(authenticate),
    TypedMiddleware<AppState, LoadedUserConfigurationAction>(loginProcessDone),
    TypedMiddleware<AppState, LoadPeriodsAction>(loadPeriods),
  ];
}

Middleware<AppState> _createLoadCompanies(Api api) {
  return (Store<AppState> store, action, NextDispatcher next) {
    store.dispatch(UpdateCompanyIsLoadingAction(true));

    api.getCompanies(store.state.userViewModel.token).then((companies) {
      store.dispatch(LoadedCompaniesAction(companies));
      store.dispatch(UpdateCompanyIsLoadingAction(false));
    });

    next(action);
  };
}

Middleware<AppState> _createLoadAppointments(Api api) {
  return (Store<AppState> store, action, NextDispatcher next) {
    store.dispatch(UpdateAppointmentsIsLoadingAction(true));

    api
        .getAppointments(action.userId, store.state.userViewModel.token)
        .then((appointments) {
      store.dispatch(LoadedAppointmentsAction(appointments));
      store.dispatch(UpdateAppointmentsIsLoadingAction(false));
    });

    next(action);
  };
}

Middleware<AppState> _loadedUserConfigurationAction() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(kUserIdKey, action.user.id);
    sharedPreferences.setString(kTokenKey, action.token);

    store.dispatch(LoadedUserAction(action.user, action.token));
    store.dispatch(LoadCategoriesAction());
    store.dispatch(UpdateLoginProcessIsActiveAction(false));

    next(action);
  };
}

///fetches periods which aren't already in cache
Middleware<AppState> _createLoadPeriods(Api api) {
  return (Store<AppState> store, action, NextDispatcher next) async {
    store.dispatch(UpdateIsLoadingAction(true));

    final oneDay = const Duration(days: 1);
    bool allAvailable = false;

    //dates from the action might have hours and minutes set. But ArePeriodsAvailable checks only if year, month, and day are available
    final startDate =
        DateTime(action.first.year, action.first.month, action.first.day);
    DateTime dateCounterLeft = startDate;

    final endDate =
        DateTime(action.last.year, action.last.month, action.last.day);
    DateTime dateCounterRight = endDate;
    while (arePeriodsAvailable(
        store.state.selectPeriodViewModel, dateCounterLeft)) {
      if (dateCounterLeft == endDate) {
        allAvailable = true;
        break;
      }

      dateCounterLeft = dateCounterLeft.add(oneDay);
    }

    if (!allAvailable) {
      while (arePeriodsAvailable(
          store.state.selectPeriodViewModel, dateCounterRight)) {
        if (dateCounterRight == startDate) {
          break;
        }
        dateCounterRight = dateCounterRight.subtract(oneDay);
      }

      print(
          "load Periods between: ${dateCounterLeft.toString()} - ${dateCounterRight.toString()}");

      api
          .getPeriods(action.companyId, dateCounterLeft, dateCounterRight)
          .then((result) {
        store.dispatch(LoadedPeriodsAction(result));
        print(
            "loaded Periods for: ${dateCounterLeft.toString()} - ${dateCounterRight.toString()}");

        store.dispatch(UpdateIsLoadingAction(false));
      });
    } else {
      store.dispatch(UpdateIsLoadingAction(false));
      print("load periods; all available");
    }
  };
}

Middleware<AppState> _authenticate(Api api) {
  return (Store<AppState> store, action, NextDispatcher next) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    print("authentication soon");

    if (sharedPreferences.containsKey(kTokenKey)) {
      store.dispatch(UpdateLoginProcessIsActiveAction(true));

      print("user is authenticated");
      final token = sharedPreferences.getString(kTokenKey);
      final userId = sharedPreferences.getString(kUserIdKey);

      api.token = token;

      api.getUser(userId, token).then((user) {
        if (user != null) {
          store.dispatch(LoadedUserConfigurationAction(user, token));
        }
        store.dispatch(UpdateLoginProcessIsActiveAction(false));
      });
    } else {
      print("user isnot authenticated");
    }

    next(action);
  };
}

Middleware<AppState> _createUserVerifcation(Api api) {
  return (Store<AppState> store, action, next) {
    store.dispatch(UpdateUserLoadingAction(true));

    api
        .postUserVerificationCode(action.userId, action.verificationCode,
            store.state.userViewModel.token)
        .then((result) {
      store.dispatch(VerifyUserResultAction(result));
      store.dispatch(UpdateUserLoadingAction(false));
    });

    next(action);
  };
}

Middleware<AppState> _createLoadCategories(Api api) {
  return (Store<AppState> store, action, next) {
    //TODO: check, if categories should use a own viewmodel
    store.dispatch(UpdateCompanyIsLoadingAction(true));

    api.getCategories(store.state.userViewModel.token).then((result) {
      result.insert(0, Category(id: -1, value: "Alle"));
      store.dispatch(LoadedCategoriesAction(result));
      store.dispatch(UpdateCompanyIsLoadingAction(false));
    });

    next(action);
  };
}

Middleware<AppState> _createLoadSharedPreferences() {
  return (Store<AppState> store, action, next) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    final keys = sharedPreferences.getKeys();
    Map<dynamic, dynamic> settings = {};
    keys.forEach((k) {
      print("setting loaded: $k");
      settings[k] = sharedPreferences.get(k);
    });

    store.dispatch(LoadedSharedPreferencesAction(settings));

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
    store.dispatch(UpdateIsLoadingFavoritesAction(true));
    api
        .getUserFavorites(action.userId, store.state.userViewModel.token)
        .then((result) {
      store.dispatch(LoadedFavoritesAction(result));
      store.dispatch(UpdateIsLoadingFavoritesAction(false));
    });

    next(action);
  };
}

Middleware<AppState> _createRemoveFromUserFavorites(Api api) {
  return (Store<AppState> store, action, next) {
    api
        .removeUserFavorites(
            action.userId, action.companyIds, store.state.userViewModel.token)
        .then((res) {
      //TODO: use user.favorites stream to reload them
    });

    next(action);
  };
}

Middleware<AppState> _createAddToUserFavorites(Api api) {
  return (Store<AppState> store, action, next) {
    api
        .addUserFavorite(
            action.userId, action.companyId, store.state.userViewModel.token)
        .then((res) {
      //TODO: use user.favorites stream to reload them
    });

    next(action);
  };
}
