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
  final Category filter;

  UpdateCategoryFilterAction(this.filter);
}

class UpdateRangeFilterAction {
  final double range;

  UpdateRangeFilterAction(this.range);
}