import 'package:appoint/models/app_state.dart';
import 'package:appoint/reducers/add_appoint_reducer.dart';
import 'package:appoint/reducers/appointments_reducer.dart';
import 'package:appoint/reducers/companies_reducer.dart';
import 'package:appoint/reducers/favorites_reducer.dart';
import 'package:appoint/reducers/select_period_reducer.dart';
//import 'package:appoint/reducers/signin_reducer.dart';
import 'package:appoint/reducers/user_reducer.dart';

AppState appReducer(AppState state, action) {
  return AppState(
    selectCompanyViewModel:
        selectCompanyReducer(state.selectCompanyViewModel, action),
    selectPeriodViewModel:
        selectPeriodReudcer(state.selectPeriodViewModel, action),
    addAppointViewModel: addAppointReducer(state.addAppointViewModel, action),
    appointmentsViewModel:
        appointmentsReducer(state.appointmentsViewModel, action),
    userViewModel: userReducer(state.userViewModel, action),
    favoritesViewModel: favoritesReducer(state.favoritesViewModel, action),
    //signInViewModel: signInReducer(state.signInViewModel, action),
  );
}
