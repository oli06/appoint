import 'package:appoint/models/category.dart';
import 'package:appoint/models/company.dart';

class SelectCompanyViewModel {
  final List<Company> companies;
  final bool isLoading;
  final CompanyVisibilityFilter companyVisibilityFilter;
  final int categoryFilter;
  final double rangeFilter;
  final List<Category> categories;

  const SelectCompanyViewModel({
    this.companies,
    this.isLoading,
    this.companyVisibilityFilter,
    this.categoryFilter,
    this.rangeFilter,
    this.categories,
  });
}
