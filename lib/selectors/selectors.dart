import 'package:appoint/models/app_state.dart';
import 'package:appoint/models/company.dart';
import 'package:appoint/models/period.dart';

List<Company> companiesSelector(AppState state) =>
    state.selectCompanyViewModel.companies;

CompanyVisibilityFilter activeCompanyFilterSelector(AppState state) =>
    state.selectCompanyViewModel.companyVisibilityFilter;

List<Company> companiesVisibilityFilterSelector(List<Company> companies,
    CompanyVisibilityFilter filter) {
  return companies.where((cpy) {
    if (filter == CompanyVisibilityFilter.favorites) {
      return true;//TODO
    } else if (filter == CompanyVisibilityFilter.all) {
      return true;
    }
  }).toList();
}

List<Company> companiesCategoryFilterSelector(List<Company> companies, Category categoryFilter) {
  return companies.where((cpy) {
    switch (categoryFilter) {
      case Category.ALL:
        return true;
      default:
        return cpy.category == categoryFilter;
    }
  }).toList();
}

List<Period> filteredPeriodsSelector(List<Period> periods, List<bool> filter) {
  return periods.where((p) {
    final int index = p.start.weekday - 1;
    return filter[index];
  }).toList();
}
