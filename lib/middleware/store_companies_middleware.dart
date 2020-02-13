import 'package:appoint/actions/appointments_action.dart';
import 'package:appoint/actions/companies_action.dart';
import 'package:appoint/actions/favorites_action.dart';
import 'package:appoint/actions/past_appointments_action.dart';
import 'package:appoint/actions/select_period_action.dart';
import 'package:appoint/actions/settings_action.dart';
import 'package:appoint/actions/user_action.dart';
import 'package:appoint/data/api.dart';
import 'package:appoint/data/api_base.dart';
import 'package:appoint/enums/enums.dart';
import 'package:appoint/models/app_state.dart';
import 'package:appoint/models/category.dart';
import 'package:appoint/selectors/selectors.dart';
import 'package:appoint/utils/constants.dart';
import 'package:appoint/utils/logger.dart';
//import 'package:localstorage/localstorage.dart';
import 'package:logger/logger.dart';
import 'package:redux/redux.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<Middleware<AppState>> createStoreCompaniesMiddleware(
    ApiBase api, SharedPreferences sharedPreferences) {
  Logger logger = getLogger('middleware');

  final loadAppointments = _createLoadAppointments(api);
  final loadPastAppointments = _createLoadPastAppointments(api);
  final verifyUser = _createUserVerifcation(api);
  final loadUserLocation = _createLoadUserLocation();
  final loadUserFavorites = _createLoadUserFavorites(api);
  final removeUserFavorites = _createRemoveFromUserFavorites(api);
  final addUserFavorite = _createAddToUserFavorites(api);
  final loadSharedPreferences = _createLoadSharedPreferences(logger);
  final loadCategories = _createLoadCategories(api);

  final authenticate = _authenticate(api, sharedPreferences, logger);
  final loginProcessDone =
      _loadedUserConfigurationAction(sharedPreferences, logger);
  final loadPeriods = _createLoadPeriods(api, logger);

  final updateApi = _updateApiPropertiesAction(api);

  return [
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
    TypedMiddleware<AppState, UpdateApiPropertiesAction>(updateApi),
    TypedMiddleware<AppState, LoadPastAppointments>(loadPastAppointments),
  ];
}

Middleware<AppState> _createLoadAppointments(ApiBase api) {
  return (Store<AppState> store, action, NextDispatcher next) {
    store.dispatch(UpdateAppointmentsIsLoadingAction(true));

    api.getAppointments().then((appointments) {
      store.dispatch(LoadedAppointmentsAction(appointments));
      store.dispatch(UpdateAppointmentsIsLoadingAction(false));
    });

    next(action);
  };
}

Middleware<AppState> _createLoadPastAppointments(ApiBase api) {
  return (Store<AppState> store, action, NextDispatcher next) {
    store.dispatch(UpdatePastAppointmentsIsLoadingAction(true));

    api.getPastAppointments().then((appointments) {
      store.dispatch(LoadedPastAppointmentsAction(appointments));
      store.dispatch(UpdatePastAppointmentsIsLoadingAction(false));
    });

    next(action);
  };
}

Middleware<AppState> _loadedUserConfigurationAction(
    SharedPreferences sharedPreferences, Logger logger) {
  return (Store<AppState> store, action, NextDispatcher next) {
    logger.d("loaded shared preferences");

    sharedPreferences.setInt(kUserIdKey, action.user.id);
    sharedPreferences.setString(kTokenKey, action.token);

    store.dispatch(LoadedUserAction(action.user, action.token));
    store.dispatch(LoadCategoriesAction());
    store.dispatch(UpdateLoginProcessIsActiveAction(false));

    //next(action);
  };
}

Middleware<AppState> _updateApiPropertiesAction(ApiBase api) {
  return (Store<AppState> store, action, NextDispatcher next) {
    api.token = action.token;
    api.userId = action.userId;
  };
}

///fetches periods which aren't already in cache
Middleware<AppState> _createLoadPeriods(ApiBase api, Logger logger) {
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

      logger.d(
          "load Periods between: ${dateCounterLeft.toString()} - ${dateCounterRight.toString()}");

      api
          .getPeriods(action.companyId, dateCounterLeft, dateCounterRight)
          .then((result) {
        store.dispatch(LoadedPeriodsAction(result));
        logger.d(
            "loaded Periods for: ${dateCounterLeft.toString()} - ${dateCounterRight.toString()}");

        store.dispatch(UpdateIsLoadingAction(false));
      });
    } else {
      store.dispatch(UpdateIsLoadingAction(false));
      logger.d("load periods; all available");
    }
  };
}

Middleware<AppState> _authenticate(
    ApiBase api, SharedPreferences sharedPreferences, Logger logger) {
  return (Store<AppState> store, action, NextDispatcher next) {
    logger.d("authenticate");

    if (sharedPreferences.containsKey(kTokenKey)) {
      store.dispatch(UpdateLoginProcessIsActiveAction(true));

      final token = sharedPreferences.getString(kTokenKey);
      final userId = sharedPreferences.getInt(kUserIdKey);
      logger.i("user $userId is authenticated");

      api.token = token;
      api.userId = userId;

      // load data from storage
      if (sharedPreferences.containsKey(kLastSyncFlag)) {
        api.getSyncFlags().then((syncFlags) {
          final lastSync =
              DateTime.parse(sharedPreferences.getString(kLastSyncFlag));

          if (!syncFlags.data.lastModified.isBefore(lastSync)) {
            //load userData from storage
          }

          if (lastSync.isBefore(syncFlags.data.appointmentsLastModified)) {
            //load appointments
          }
        });
      }

      api.getUser().then((response) {
        if (response.success) {
          store.dispatch(LoadedUserConfigurationAction(response.data, token));
        } else {
          logger.e(
              "getUser failed: ${response.error.error} ${response.error.errorDescription} (${response.statusCode})");
        }
        store.dispatch(UpdateLoginProcessIsActiveAction(false));
      });
    } else {
      logger.i("user isnot authenticated");
    }

    next(action);
  };
}

Middleware<AppState> _createUserVerifcation(ApiBase api) {
  return (Store<AppState> store, action, next) {
    store.dispatch(UpdateUserLoadingAction(true));

    api.verifyUser(action.verificationCode).then((result) {
      store.dispatch(VerifyUserResultAction(result));
      store.dispatch(UpdateUserLoadingAction(false));
    });

    next(action);
  };
}

Middleware<AppState> _createLoadCategories(ApiBase api) {
  return (Store<AppState> store, action, next) {
    //TODO: check, if categories should use a own viewmodel

    api.getCategories().then((result) {
      result.insert(0, Category(id: -1, value: "Alle"));
      store.dispatch(LoadedCategoriesAction(result));
    });

    next(action);
  };
}

Middleware<AppState> _createLoadSharedPreferences(Logger logger) {
  return (Store<AppState> store, action, next) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    Map<String, dynamic> settings = {};
    kSettingKeys.forEach((s) {
      if (sharedPreferences.containsKey(s)) {
        settings[s] = sharedPreferences.get(s);
      } else {
        logger.i("setting $s is not available");
      }
    });

    store.dispatch(LoadedSharedPreferencesAction(settings));
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

Middleware<AppState> _createLoadUserFavorites(ApiBase api) {
  return (Store<AppState> store, action, next) {
    store.dispatch(UpdateIsLoadingFavoritesAction(true));
    api
        .getCompanies(getCompanySearchString(
            visibility: CompanyVisibilityFilter.favorites,
            range: double.infinity))
        .then((result) {
      store.dispatch(LoadedFavoritesAction(result));
      store.dispatch(UpdateIsLoadingFavoritesAction(false));
    });

    next(action);
  };
}

Middleware<AppState> _createRemoveFromUserFavorites(ApiBase api) {
  return (Store<AppState> store, action, next) {
    api.removeUserFavorites(action.companyIds).then((res) {
      //TODO: use user.favorites stream to reload them
    });

    next(action);
  };
}

Middleware<AppState> _createAddToUserFavorites(ApiBase api) {
  return (Store<AppState> store, action, next) {
    api.addUserFavorite(action.companyId).then((res) {
      //TODO: use user.favorites stream to reload them
    });

    next(action);
  };
}
