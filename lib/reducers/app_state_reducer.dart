import 'package:appoint/model/app_state.dart';
import 'package:appoint/reducers/active_company_filter_reducer.dart';
import 'package:appoint/reducers/add_appoint_reducer.dart';
import 'package:appoint/reducers/companies_reducer.dart';
import 'package:appoint/reducers/select_period_reducer.dart';

AppState appReducer(AppState state, action) {
  return AppState(
    companies: companiesReducer(state.companies, action),
    activeCompanyFilter:
        activeCompanyFilterReducer(state.activeCompanyFilter, action),
    selectPeriodViewModel:
        selectPeriodReudcer(state.selectPeriodViewModel, action),
    addAppointViewModel: addAppointReducer(state.addAppointViewModel, action),
  );
}
