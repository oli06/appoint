import 'package:appoint/middleware/search_epic.dart';
import 'package:appoint/models/category.dart';
import 'package:appoint/models/company.dart';

class SelectCompanyViewModel {
  //final bool isLoading;
  final List<Category> categories;
  final CompanySearchState companySearchState;
  final CompanyVisibilityFilter companyVisibilityFilter;
  final int categoryFilter;
  final double rangeFilter;
  final String nameFilter;

  const SelectCompanyViewModel({
    //this.isLoading,
    this.categories,
    this.companySearchState,
    this.companyVisibilityFilter = CompanyVisibilityFilter.all,
    this.categoryFilter = -1,
    this.rangeFilter = 9.0,
    this.nameFilter = "",
  });
}
