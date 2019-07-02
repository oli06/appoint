import 'package:appoint/actions/companies_action.dart';
import 'package:appoint/model/company.dart';
import 'package:redux/redux.dart';

final companiesReducer = combineReducers<List<Company>>([
  TypedReducer<List<Company>, LoadedCompaniesAction>(_setLoadedCompanies),
]);

List<Company> _setLoadedCompanies(List<Company> companies, LoadedCompaniesAction action) {
  return action.companies;
}
