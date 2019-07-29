import 'package:appoint/models/category.dart';
import 'package:appoint/models/company.dart';

class LoadedCompaniesAction {
  final List<Company> companies;

  LoadedCompaniesAction(this.companies);
}

class LoadCompaniesAction {}

class UpdateCompanyIsLoadingAction {
  final bool isLoading;

  UpdateCompanyIsLoadingAction(this.isLoading);
}

class UpdateCompanyVisibilityFilterAction {
  final CompanyVisibilityFilter filter;

  UpdateCompanyVisibilityFilterAction(this.filter);
}

class UpdateCategoryFilterAction {
  final int categoryId;

  UpdateCategoryFilterAction(this.categoryId);
}

class UpdateRangeFilterAction {
  final double range;

  UpdateRangeFilterAction(this.range);
}

class LoadCategoriesAction {}

class LoadedCategoriesAction {
  final List<Category> categories;

  LoadedCategoriesAction(this.categories);
}