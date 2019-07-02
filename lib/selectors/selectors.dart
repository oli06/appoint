import 'package:appoint/model/app_state.dart';
import 'package:appoint/model/company.dart';

List<Company> companiesSelector(AppState state) => state.companies;

CompanyVisibilityFilter activeCompanyFilterSelector(AppState state) => state.activeCompanyFilter;

List<Company> filteredCompaniesSelector(
    List<Company> companies, CompanyVisibilityFilter filter) {
  return companies.where((cpy) {
    if (filter == CompanyVisibilityFilter.favorites) {
      return false; //TODO
    } else if(filter == CompanyVisibilityFilter.category) {
      return true;
    } else if(filter == CompanyVisibilityFilter.all) {
      return true;
    }
  }).toList();
}
