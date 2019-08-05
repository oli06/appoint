import 'package:appoint/middleware/search_epic.dart';
import 'package:appoint/models/category.dart';
import 'package:appoint/models/company.dart';

class SelectCompanyViewModel {
  final List<Company> companies;
  final bool isLoading;
  final List<Category> categories;
  final CompanySearchState companySearchState;
  final CompanySearchFilter filters;

  const SelectCompanyViewModel({
    this.filters,
    this.companies,
    this.isLoading,
    this.categories,
    this.companySearchState,
  });
}
