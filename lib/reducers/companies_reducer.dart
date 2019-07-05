import 'package:appoint/actions/companies_action.dart';
import 'package:appoint/view_models/select_company_vm.dart';
import 'package:redux/redux.dart';

final selectCompanyReducer = combineReducers<SelectCompanyViewModel>([
  TypedReducer<SelectCompanyViewModel, LoadedCompaniesAction>(
      _setLoadedCompanies),
  TypedReducer<SelectCompanyViewModel, UpdateCompanyIsLoadingAction>(
      _updateIsLoading),
  TypedReducer<SelectCompanyViewModel, UpdateCompanyVisibilityFilter>(
      _updateCompanyVisibilityFilter),
  TypedReducer<SelectCompanyViewModel, UpdateCategoryFilter>(
      _updateCategoryFilter),
]);

SelectCompanyViewModel _setLoadedCompanies(
    SelectCompanyViewModel vm, LoadedCompaniesAction action) {
  return SelectCompanyViewModel(
    isLoading: vm.isLoading,
    companies: action.companies,
    companyVisibilityFilter: vm.companyVisibilityFilter,
    categoryFilter: vm.categoryFilter,
  );
}

SelectCompanyViewModel _updateIsLoading(
    SelectCompanyViewModel vm, UpdateCompanyIsLoadingAction action) {
  return SelectCompanyViewModel(
    isLoading: action.isLoading,
    companies: vm.companies,
    companyVisibilityFilter: vm.companyVisibilityFilter,
    categoryFilter: vm.categoryFilter,
  );
}

SelectCompanyViewModel _updateCompanyVisibilityFilter(
    SelectCompanyViewModel vm, UpdateCompanyVisibilityFilter action) {
  return SelectCompanyViewModel(
    isLoading: vm.isLoading,
    companies: vm.companies,
    companyVisibilityFilter: action.filter,
    categoryFilter: vm.categoryFilter,
  );
}

SelectCompanyViewModel _updateCategoryFilter(
    SelectCompanyViewModel vm, UpdateCategoryFilter action) {
  return SelectCompanyViewModel(
      isLoading: vm.isLoading,
      companies: vm.companies,
      companyVisibilityFilter: vm.companyVisibilityFilter,
      categoryFilter: action.filter);
}
