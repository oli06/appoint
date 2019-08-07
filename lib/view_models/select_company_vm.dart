import 'package:appoint/enums/enums.dart';
import 'package:appoint/middleware/search_epic.dart';
import 'package:appoint/models/category.dart';

class SelectCompanyViewModel {
  final List<Category> categories;
  final CompanySearchState companySearchState;
  final CompanyVisibilityFilter companyVisibilityFilter;
  final int categoryFilter;
  final double rangeFilter;
  final String nameFilter;

  const SelectCompanyViewModel({
    this.categories,
    this.companySearchState,
    this.companyVisibilityFilter = CompanyVisibilityFilter.all,
    this.categoryFilter = -1,
    this.rangeFilter = 9.0,
    this.nameFilter = "",
  });

  @override
  int get hashCode =>
      categories.hashCode ^
      companySearchState.hashCode ^
      companyVisibilityFilter.hashCode ^
      categoryFilter.hashCode ^
      rangeFilter.hashCode ^
      nameFilter.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SelectCompanyViewModel &&
          runtimeType == other.runtimeType &&
          categories == other.categories &&
          companySearchState == other.companySearchState &&
          companyVisibilityFilter == other.companyVisibilityFilter &&
          categoryFilter == other.categoryFilter &&
          rangeFilter == other.rangeFilter &&
          nameFilter == other.nameFilter;
}
