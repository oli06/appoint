import 'package:appoint/models/company.dart';

class SelectCompanyViewModel {
  final List<Company> companies;
  final bool isLoading;
  final CompanyVisibilityFilter companyVisibilityFilter;
  final Category categoryFilter;

  const SelectCompanyViewModel({
    this.companies,
    this.isLoading,
    this.companyVisibilityFilter,
    this.categoryFilter
  });
}