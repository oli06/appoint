import 'package:appoint/actions/company_filter_action.dart';
import 'package:appoint/model/company.dart';
import 'package:redux/redux.dart';

final activeCompanyFilterReducer = combineReducers<CompanyVisibilityFilter>([
  TypedReducer<CompanyVisibilityFilter, UpdateFilterAction>(
      _activeFilterReducer),
]);

CompanyVisibilityFilter _activeFilterReducer(
    CompanyVisibilityFilter filter, UpdateFilterAction action) {
  return action.newFilter;
}
