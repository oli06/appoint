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

class UpdateCompanyVisibilityFilter {
  final CompanyVisibilityFilter filter;

  UpdateCompanyVisibilityFilter(this.filter);
}

class UpdateCategoryFilter {
  final Category filter;

  UpdateCategoryFilter(this.filter);
}