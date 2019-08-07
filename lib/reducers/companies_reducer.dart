import 'package:appoint/actions/companies_action.dart';
import 'package:appoint/middleware/search_epic.dart';
import 'package:appoint/view_models/select_company_vm.dart';
import 'package:redux/redux.dart';

final selectCompanyReducer = combineReducers<SelectCompanyViewModel>([
/*   TypedReducer<SelectCompanyViewModel, LoadedCompaniesAction>(
      _setLoadedCompanies), */
/*   TypedReducer<SelectCompanyViewModel, UpdateCompanyIsLoadingAction>(
      _updateIsLoading), */
  TypedReducer<SelectCompanyViewModel, LoadedCategoriesAction>(
      _loadedCategories),
  TypedReducer<SelectCompanyViewModel, CompanySearchResultAction>(
      _searchResult),
  TypedReducer<SelectCompanyViewModel, CompanySearchLoadingAction>(
      _updateSearchStateLoading),

  //search filter reducers
  TypedReducer<SelectCompanyViewModel, CompanyFilterSearchAction>(
      _updateCompanySearchFilter),
  TypedReducer<SelectCompanyViewModel, CompanyFilterCategoryAction>(
      _updateCompanyCategoryFilter),
  TypedReducer<SelectCompanyViewModel, ResetCompanyNameSearchFilterAction>(
      _resetCompanyNameSearchFilter),
  TypedReducer<SelectCompanyViewModel, CompanyFilterRangeAction>(
      _updateCompanyRangeFilter),
  TypedReducer<SelectCompanyViewModel, CompanyFilterVisibilityAction>(
      _updateCompanyVisibilityFilter),
]);

SelectCompanyViewModel _updateCompanySearchFilter(
    SelectCompanyViewModel vm, CompanyFilterSearchAction action) {
  return SelectCompanyViewModel(
    categoryFilter: vm.categoryFilter,
    companyVisibilityFilter: vm.companyVisibilityFilter,
    nameFilter: action.search,
    rangeFilter: vm.rangeFilter,
    companySearchState: vm.companySearchState,
    categories: vm.categories,
  );
}

SelectCompanyViewModel _updateCompanyCategoryFilter(
    SelectCompanyViewModel vm, CompanyFilterCategoryAction action) {
  return SelectCompanyViewModel(
    categoryFilter: action.category,
    companyVisibilityFilter: vm.companyVisibilityFilter,
    nameFilter: vm.nameFilter,
    rangeFilter: vm.rangeFilter,
    companySearchState: vm.companySearchState,
    categories: vm.categories,
  );
}

SelectCompanyViewModel _updateCompanyVisibilityFilter(
    SelectCompanyViewModel vm, CompanyFilterVisibilityAction action) {
  return SelectCompanyViewModel(
    categoryFilter: vm.categoryFilter,
    companyVisibilityFilter: action.visibility,
    nameFilter: vm.nameFilter,
    rangeFilter: vm.rangeFilter,
    companySearchState: vm.companySearchState,
    categories: vm.categories,
  );
}

SelectCompanyViewModel _updateCompanyRangeFilter(
    SelectCompanyViewModel vm, CompanyFilterRangeAction action) {
  print("called range update reducer");

  return SelectCompanyViewModel(
    categoryFilter: vm.categoryFilter,
    companyVisibilityFilter: vm.companyVisibilityFilter,
    nameFilter: vm.nameFilter,
    rangeFilter: action.range,
    companySearchState: vm.companySearchState,
    categories: vm.categories,
  );
}

SelectCompanyViewModel _resetCompanyNameSearchFilter(
    SelectCompanyViewModel vm, ResetCompanyNameSearchFilterAction action) {
  return SelectCompanyViewModel(
    categoryFilter: vm.categoryFilter,
    companyVisibilityFilter: vm.companyVisibilityFilter,
    nameFilter: "",
    rangeFilter: vm.rangeFilter,
    companySearchState: vm.companySearchState,
    categories: vm.categories,
  );
}

SelectCompanyViewModel _searchResult(
    SelectCompanyViewModel vm, CompanySearchResultAction action) {
  return SelectCompanyViewModel(
    categoryFilter: vm.categoryFilter,
    companyVisibilityFilter: vm.companyVisibilityFilter,
    nameFilter: vm.nameFilter,
    rangeFilter: vm.rangeFilter,
    companySearchState:
        CompanySearchState(searchResults: action.result, isLoading: false),
    categories: vm.categories,
  );
}

SelectCompanyViewModel _loadedCategories(
    SelectCompanyViewModel vm, LoadedCategoriesAction action) {
  return SelectCompanyViewModel(
    categoryFilter: vm.categoryFilter,
    companyVisibilityFilter: vm.companyVisibilityFilter,
    nameFilter: vm.nameFilter,
    rangeFilter: vm.rangeFilter,
    companySearchState: vm.companySearchState,
    categories: action.categories,
  );
}

SelectCompanyViewModel _updateSearchStateLoading(
    SelectCompanyViewModel vm, CompanySearchLoadingAction action) {
  return SelectCompanyViewModel(
    categories: vm.categories,
    categoryFilter: vm.categoryFilter,
    companyVisibilityFilter: vm.companyVisibilityFilter,
    nameFilter: vm.nameFilter,
    rangeFilter: vm.rangeFilter,
    companySearchState: CompanySearchState.loading(),
  );
}
