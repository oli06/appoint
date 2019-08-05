import 'package:appoint/actions/companies_action.dart';
import 'package:appoint/middleware/search_epic.dart';
import 'package:appoint/view_models/select_company_vm.dart';
import 'package:redux/redux.dart';

final selectCompanyReducer = combineReducers<SelectCompanyViewModel>([
  TypedReducer<SelectCompanyViewModel, LoadedCompaniesAction>(
      _setLoadedCompanies),
  TypedReducer<SelectCompanyViewModel, UpdateCompanyIsLoadingAction>(
      _updateIsLoading),
  TypedReducer<SelectCompanyViewModel, LoadedCategoriesAction>(
      _loadedCategories),
  TypedReducer<SelectCompanyViewModel, CompanySearchResultAction>(
      _searchResult),
  TypedReducer<SelectCompanyViewModel, CompanySearchLoadingAction>(
      _updateSearchStateLoading),
  TypedReducer<SelectCompanyViewModel, CompanySearchAction>(
      _updateCompanySearchFilters2),
]);

SelectCompanyViewModel _updateCompanySearchFilters2(
    SelectCompanyViewModel vm, CompanySearchAction action) {

  return SelectCompanyViewModel(
    isLoading: vm.isLoading,
    companies: vm.companies,
    filters: action.filters,
    companySearchState: vm.companySearchState,
    categories: vm.categories,
  );
}

SelectCompanyViewModel _searchResult(
    SelectCompanyViewModel vm, CompanySearchResultAction action) {
  return SelectCompanyViewModel(
    isLoading: vm.isLoading,
    companies: vm.companies,
    filters: vm.filters,
    companySearchState:
        CompanySearchState(searchResults: action.result, isLoading: false),
    categories: vm.categories,
  );
}

SelectCompanyViewModel _setLoadedCompanies(
    SelectCompanyViewModel vm, LoadedCompaniesAction action) {
  return SelectCompanyViewModel(
    isLoading: vm.isLoading,
    companies: action.companies,
    categories: vm.categories,
    filters: vm.filters,
    companySearchState: vm.companySearchState,
  );
}

SelectCompanyViewModel _loadedCategories(
    SelectCompanyViewModel vm, LoadedCategoriesAction action) {
  return SelectCompanyViewModel(
    isLoading: vm.isLoading,
    companies: vm.companies,
    filters: vm.filters,
    companySearchState: vm.companySearchState,
    categories: action.categories,
  );
}

SelectCompanyViewModel _updateIsLoading(
    SelectCompanyViewModel vm, UpdateCompanyIsLoadingAction action) {
  return SelectCompanyViewModel(
    isLoading: action.isLoading,
    companies: vm.companies,
    categories: vm.categories,
    filters: vm.filters,
    companySearchState: vm.companySearchState,
  );
}

SelectCompanyViewModel _updateSearchStateLoading(
    SelectCompanyViewModel vm, CompanySearchLoadingAction action) {
  return SelectCompanyViewModel(
    isLoading: vm.isLoading,
    companies: vm.companies,
    categories: vm.categories,
    filters: vm.filters,
    companySearchState: CompanySearchState.loading(),
  );
}
