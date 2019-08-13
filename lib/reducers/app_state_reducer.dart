import 'package:appoint/models/app_state.dart';
import 'package:appoint/reducers/appointments_reducer.dart';
import 'package:appoint/reducers/companies_reducer.dart';
import 'package:appoint/reducers/favorites_reducer.dart';
import 'package:appoint/reducers/past_appointments_reducer.dart';
import 'package:appoint/reducers/select_period_reducer.dart';
import 'package:appoint/reducers/user_reducer.dart';
import 'package:appoint/reducers/settings_reducer.dart';

AppState appReducer(AppState state, action) {
  return AppState(
    selectCompanyViewModel:
        selectCompanyReducer(state.selectCompanyViewModel, action),
    selectPeriodViewModel:
        selectPeriodReudcer(state.selectPeriodViewModel, action),
    appointmentsViewModel:
        appointmentsReducer(state.appointmentsViewModel, action),
    userViewModel: userReducer(state.userViewModel, action),
    favoritesViewModel: favoritesReducer(state.favoritesViewModel, action),
    pastAppointmentsViewModel:
        pastAppointmentsReducer(state.pastAppointmentsViewModel, action),
    settingsViewModel: settingsReducer(state.settingsViewModel, action),
  );
}
