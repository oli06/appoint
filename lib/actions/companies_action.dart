import 'package:appoint/enums/enums.dart';
import 'package:appoint/models/category.dart';
import 'package:appoint/models/company.dart';

class LoadCategoriesAction {}

class LoadedCategoriesAction {
  final List<Category> categories;

  LoadedCategoriesAction(this.categories);
}

class CompanyFilterSearchAction {
  final String search;

  CompanyFilterSearchAction(this.search);
}

class CompanyFilterRangeAction {
  final double range;

  CompanyFilterRangeAction(this.range);
}

class CompanyFilterCategoryAction {
  final int category;

  CompanyFilterCategoryAction(this.category);
}

class CompanyFilterVisibilityAction {
  final CompanyVisibilityFilter visibility;

  CompanyFilterVisibilityAction(this.visibility);
}

class CompanySearchLoadingAction {}

class ResetCompanyNameSearchFilterAction {}

class CompanySearchResultAction {
  final List<Company> result;

  CompanySearchResultAction(this.result);
}

class CompanySearchErrorAction {}
