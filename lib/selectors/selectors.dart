import 'package:appoint/model/app_state.dart';
import 'package:appoint/model/company.dart';
import 'package:appoint/model/period.dart';

List<Company> companiesSelector(AppState state) => state.companies;

CompanyVisibilityFilter activeCompanyFilterSelector(AppState state) =>
    state.activeCompanyFilter;

List<Company> filteredCompaniesSelector(
    List<Company> companies, CompanyVisibilityFilter filter) {
  return companies.where((cpy) {
    if (filter == CompanyVisibilityFilter.favorites) {
      return false; //TODO
    } else if (filter == CompanyVisibilityFilter.all) {
      return true;
    }
  }).toList();
}

List<Period> filteredPeriodsSelector(List<Period> periods, List<bool> filter) {
  return periods.where((p) {
    final int index = p.start.weekday - 1;
    return filter[index];
  }).toList();
}
