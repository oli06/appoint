import 'package:appoint/middleware/search_epic.dart';
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

class LoadCategoriesAction {}

class LoadedCategoriesAction {
  final List<Category> categories;

  LoadedCategoriesAction(this.categories);
}

class CompanySearchAction {
  final CompanySearchFilter filters;

  CompanySearchAction(this.filters);
}

class CompanySearchLoadingAction {}

class CompanySearchResultAction {
  final List<Company> result;

  CompanySearchResultAction(this.result);
}

class CompanySearchErrorAction {}