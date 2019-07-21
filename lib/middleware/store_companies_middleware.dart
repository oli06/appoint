import 'package:appoint/actions/appointments_action.dart';
import 'package:appoint/actions/companies_action.dart';
import 'package:appoint/actions/favorites_action.dart';
import 'package:appoint/actions/select_period_action.dart';
import 'package:appoint/actions/settings_action.dart';
import 'package:appoint/actions/user_action.dart';
import 'package:appoint/data/api.dart';
import 'package:appoint/models/app_state.dart';
import 'package:appoint/selectors/selectors.dart';
import 'package:appoint/utils/calendar.dart';
import 'package:appoint/utils/constants.dart';
import 'package:appoint/utils/parse.dart';
import 'package:appoint/widgets/expandable_period_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<Middleware<AppState>> createStoreCompaniesMiddleware() {
  final Api api = Api();
  final Calendar calendar = Calendar();

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
  final loadSharedPreferences = _createLoadSharedPreferences();
  final loadPeriodTiles = _createLoadPeriodTiles(calendar);

  return [
    TypedMiddleware<AppState, LoadCompaniesAction>(loadCompanies),
    TypedMiddleware<AppState, LoadPeriodsAction>(loadPeriods),
    TypedMiddleware<AppState, LoadAppointmentsAction>(loadAppointments),
    TypedMiddleware<AppState, LoadUserAction>(loadUser),
    TypedMiddleware<AppState, VerifyUserAction>(verifyUser),
    TypedMiddleware<AppState, LoadUserLocationAction>(loadUserLocation),
    TypedMiddleware<AppState, LoadFavoritesAction>(loadUserFavorites),
    TypedMiddleware<AppState, RemoveFromUserFavoritesAction>(
        removeUserFavorites),
    TypedMiddleware<AppState, AddToUserFavoritesAction>(addUserFavorite),
    TypedMiddleware<AppState, RegisterUserAction>(signUpNewUser),
    TypedMiddleware<AppState, LoadSharedPreferencesAction>(
        loadSharedPreferences),
    TypedMiddleware<AppState, LoadPeriodTilesAction>(loadPeriodTiles),
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
      if (result) {
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
      store.dispatch(UpdateVisiblePeriodsAction(getVisibleDaysPeriodsList(
          store.state.selectPeriodViewModel.periods,
          store.state.selectPeriodViewModel.visibleFirstDay,
          store.state.selectPeriodViewModel.visibleLastDay)));
      store.dispatch(UpdateIsLoadingAction(false));
    });

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

Middleware<AppState> _createLoadSharedPreferences() {
  return (Store<AppState> store, action, next) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();

    final keys = sharedPreferences.getKeys();
    Map<dynamic, dynamic> settings = {};
    keys.forEach((k) {
      settings[k] = sharedPreferences.get(k);
    });

    store.dispatch(LoadedSharedPreferencesAction(settings));

    next(action);
  };
}

Middleware<AppState> _createLoadPeriodTiles(Calendar calendar) {
  return (Store<AppState> store, action, next) async {
    if (!store.state.settingsViewModel.settings[kSettingsCalendarIntegration]) {
      List<ExpandablePeriodTile> _periods = [];
      if (store.state.selectPeriodViewModel
              .visiblePeriods[store.state.selectPeriodViewModel.selectedDay] !=
          null) {
        store.state.selectPeriodViewModel
            .visiblePeriods[store.state.selectPeriodViewModel.selectedDay]
            .forEach((period) {
          _periods.add(ExpandablePeriodTile(
            period: period,
            onTap: () {
              store.dispatch(ResetSelectPeriodViewModelAction());
              Navigator.pop(action.context, period);
            },
            trailing: null,
            children: null,
          ));
        });
      }
      store.dispatch(LoadedPeriodTilesAction(_periods));
      store.dispatch(UpdateFilteredPeriodTilesAction(_periods));

      return;
    } else {
      store.dispatch(UpdateIsLoadingAction(true));

      calendar
          .retrieveCalendarEvents(
              store.state.settingsViewModel.settings[kSettingsCalendarId], action.day)
          .then((result) {
        List<ExpandablePeriodTile> _periods = [];

        if (store.state.selectPeriodViewModel.visiblePeriods[
                store.state.selectPeriodViewModel.selectedDay] !=
            null) {
          store.state.selectPeriodViewModel
              .visiblePeriods[store.state.selectPeriodViewModel.selectedDay]
              .forEach((period) {
            final eventConflicts = result.data.where((event) {
              if (event.start.isBefore(period.start) &&
                  !event.end.isBefore(period.start)) {
                return true;
              }
              if (!event.start.isBefore(period.start) &&
                  event.start.isBefore(period.start.add(period.duration))) {
                return true;
              }
              return false;
            }).toList();
            print("event conflicts are: ${eventConflicts.length}");
            _periods.add(ExpandablePeriodTile(
              period: period,
              onTap: () {
                store.dispatch(ResetSelectPeriodViewModelAction());
                Navigator.pop(action.context, period);
              },
              trailing: eventConflicts.length != 0 ? Icon(Icons.warning) : null,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Konflikte mit folgenden Terminen:",
                        style: TextStyle(fontSize: 16),
                      ),
                      ...eventConflicts
                          .map((event) => Text(
                              "${event.title}, ${Parse.hoursWithMinutes.format(event.start)} - ${Parse.hoursWithMinutes.format(event.end)}"))
                          .toList(),
                    ],
                  ),
                ),
              ],
            ));
          });
          print(
              "returning calculated data now, with leght: ${_periods.length}");
          store.dispatch(LoadedPeriodTilesAction(_periods));
          store.dispatch(UpdateFilteredPeriodTilesAction(_periods));
        } else {
          print("periods are nulll");
        }

        store.dispatch(UpdateIsLoadingAction(false));
      });
    }
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
