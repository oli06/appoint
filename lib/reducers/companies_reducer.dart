import 'package:appoint/actions/companies_action.dart';
import 'package:appoint/view_models/select_company_vm.dart';
import 'package:redux/redux.dart';

final selectCompanyReducer = combineReducers<SelectCompanyViewModel>([
  TypedReducer<SelectCompanyViewModel, LoadedCompaniesAction>(
      _setLoadedCompanies),
  TypedReducer<SelectCompanyViewModel, UpdateCompanyIsLoadingAction>(
      _updateIsLoading),
  TypedReducer<SelectCompanyViewModel, UpdateCompanyVisibilityFilterAction>(
      _updateCompanyVisibilityFilter),
  TypedReducer<SelectCompanyViewModel, UpdateCategoryFilterAction>(
      _updateCategoryFilter),
  TypedReducer<SelectCompanyViewModel, UpdateRangeFilterAction>(
      _updateRangeFilter),
  TypedReducer<SelectCompanyViewModel, LoadedCategoriesAction>(
      _loadedCategories),
]);

SelectCompanyViewModel _setLoadedCompanies(
    SelectCompanyViewModel vm, LoadedCompaniesAction action) {
  return SelectCompanyViewModel(
    isLoading: vm.isLoading,
    companies: action.companies,
    companyVisibilityFilter: vm.companyVisibilityFilter,
    categoryFilter: vm.categoryFilter,
    rangeFilter: vm.rangeFilter,
    categories: vm.categories,
  );
}
SelectCompanyViewModel _loadedCategories(
    SelectCompanyViewModel vm, LoadedCategoriesAction action) {
  return SelectCompanyViewModel(
    isLoading: vm.isLoading,
    companies: vm.companies,
    companyVisibilityFilter: vm.companyVisibilityFilter,
    categoryFilter: vm.categoryFilter,
    rangeFilter: vm.rangeFilter,
    categories: action.categories,
  );
}

SelectCompanyViewModel _updateIsLoading(
    SelectCompanyViewModel vm, UpdateCompanyIsLoadingAction action) {
  return SelectCompanyViewModel(
    isLoading: action.isLoading,
    companies: vm.companies,
    companyVisibilityFilter: vm.companyVisibilityFilter,
    categoryFilter: vm.categoryFilter,
    rangeFilter: vm.rangeFilter,
    categories: vm.categories,
  );
}

SelectCompanyViewModel _updateCompanyVisibilityFilter(
    SelectCompanyViewModel vm, UpdateCompanyVisibilityFilterAction action) {
  return SelectCompanyViewModel(
    isLoading: vm.isLoading,
    companies: vm.companies,
    companyVisibilityFilter: action.filter,
    categoryFilter: vm.categoryFilter,
    rangeFilter: vm.rangeFilter,
    categories: vm.categories,
  );
}

SelectCompanyViewModel _updateCategoryFilter(
    SelectCompanyViewModel vm, UpdateCategoryFilterAction action) {
  return SelectCompanyViewModel(
    isLoading: vm.isLoading,
    companies: vm.companies,
    companyVisibilityFilter: vm.companyVisibilityFilter,
    categoryFilter: action.categoryId,
    rangeFilter: vm.rangeFilter,
    categories: vm.categories,
  );
}

SelectCompanyViewModel _updateRangeFilter(
    SelectCompanyViewModel vm, UpdateRangeFilterAction action) {
  return SelectCompanyViewModel(
    isLoading: vm.isLoading,
    companies: vm.companies,
    categoryFilter: vm.categoryFilter,
    companyVisibilityFilter: vm.companyVisibilityFilter,
    rangeFilter: action.range,
    categories: vm.categories,
  );
}
