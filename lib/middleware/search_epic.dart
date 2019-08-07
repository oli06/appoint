import 'package:appoint/actions/companies_action.dart';
import 'package:appoint/data/api.dart';
import 'package:appoint/models/app_state.dart';
import 'package:appoint/models/company.dart';
import 'package:appoint/selectors/selectors.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/rxdart.dart';

class CompanyNameSearchEpic implements EpicClass<AppState> {
  final Api api;

  CompanyNameSearchEpic(this.api);

  @override
  Stream<dynamic> call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return Observable(actions)
        .ofType(TypeToken<CompanyFilterSearchAction>())
        .debounceTime(const Duration(milliseconds: 250))
        .switchMap((action) => _search(
              action.search,
              store.state.selectCompanyViewModel.rangeFilter,
              store.state.selectCompanyViewModel.categoryFilter,
            ));
  }

  Stream<dynamic> _search(String name, double range, int category) async* {
    yield CompanySearchLoadingAction();

    try {
      yield CompanySearchResultAction(await api.getCompanies(
          getCompanySearchString(
              name: name, range: range, category: category)));
    } catch (e) {
      yield CompanySearchErrorAction();
    }
  }
}

///Difference between CompanyNameSearchEpic and CompanyFilterSearchEpic is the missing debounce time. when Name (userinput) or range value changes this could lead to massive abuse of reqeusts
class CompanyFilterSearchEpic implements EpicClass<AppState> {
  final Api api;

  CompanyFilterSearchEpic(this.api);

  @override
  Stream<dynamic> call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return Observable(actions)
        // Narrow down to SearchAction actions
        .ofType(TypeToken<CompanyFilterRangeAction>())
        .debounceTime(const Duration(milliseconds: 100))
        // Cancel the previous search and start a new one with switchMap
        .switchMap((action) => _search(
              store.state.selectCompanyViewModel.nameFilter,
              action.range,
              store.state.selectCompanyViewModel.categoryFilter,
            ));
  }

  Stream<dynamic> _search(String name, double range, int category) async* {
    print("called search for range");
    yield CompanySearchLoadingAction();

    try {
      yield CompanySearchResultAction(await api.getCompanies(
          getCompanySearchString(
              name: name, range: range, category: category)));
    } catch (e) {
      yield CompanySearchErrorAction();
    }
  }
}

class CompanyFilterCategoryEpic implements EpicClass<AppState> {
  final Api api;

  CompanyFilterCategoryEpic(this.api);

  @override
  Stream<dynamic> call(Stream<dynamic> actions, EpicStore<AppState> store) {
    return Observable(actions)
        // Narrow down to SearchAction actions
        .ofType(TypeToken<CompanyFilterCategoryAction>())
        // Cancel the previous search and start a new one with switchMap
        .switchMap((action) => _search(
              store.state.selectCompanyViewModel.nameFilter,
              store.state.selectCompanyViewModel.rangeFilter,
              action.category,
            ));
  }

  Stream<dynamic> _search(String name, double range, int category) async* {
    print("called search for category");
    yield CompanySearchLoadingAction();

    try {
      yield CompanySearchResultAction(await api.getCompanies(
          getCompanySearchString(
              name: name, range: range, category: category)));
    } catch (e) {
      yield CompanySearchErrorAction();
    }
  }
}

class CompanySearchState {
  final bool hasError;
  final bool isLoading;
  final List<Company> searchResults;

  CompanySearchState({
    this.hasError = false,
    this.isLoading = false,
    this.searchResults,
  });

  factory CompanySearchState.initial() => CompanySearchState(searchResults: []);

  factory CompanySearchState.loading() =>
      CompanySearchState(isLoading: true, searchResults: []);

  factory CompanySearchState.error() => CompanySearchState(hasError: true);
}

/* class CompanySearchFilter {
  final CompanyVisibilityFilter companyVisibilityFilter;
  final int categoryFilter;
  final double rangeFilter;
  final String nameFilter;

  CompanySearchFilter({
    this.companyVisibilityFilter = CompanyVisibilityFilter.all,
    this.categoryFilter = -1,
    this.rangeFilter = 9.0,
    this.nameFilter = "",
  });

  CompanySearchFilter.fromExisting(
    CompanySearchFilter existingFilters, {
    companyVisibilityFilter,
    categoryFilter,
    rangeFilter,
    nameFilter,
  })  : nameFilter = nameFilter ?? existingFilters.nameFilter,
        categoryFilter = categoryFilter ?? existingFilters.categoryFilter,
        companyVisibilityFilter =
            companyVisibilityFilter ?? existingFilters.companyVisibilityFilter,
        rangeFilter = rangeFilter ?? existingFilters.rangeFilter;

  factory CompanySearchFilter.initial() => CompanySearchFilter(
        //-1 is the index of category named 'all' (gets added in loadCategoriesAction)
        categoryFilter: -1,
        companyVisibilityFilter: CompanyVisibilityFilter.all,
        rangeFilter: 9.0,
        nameFilter: "",
      );
} */
