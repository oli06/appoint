import 'package:appoint/actions/companies_action.dart';
import 'package:appoint/models/app_state.dart';
import 'package:appoint/models/category.dart';
import 'package:appoint/pages/category_select.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class CompanyCategoryButton extends StatelessWidget {
  const CompanyCategoryButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      distinct: true,
      converter: (store) => _ViewModel.fromState(store),
      builder: (context, vm) {
        print("CompanyCategoryButton build");

        return Container(
            child: FlatButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "Kategorie",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w300),
                ),
              ),
              Text(
                vm.categories
                        .firstWhere((c) => c.id == vm.categoryFilter,
                            orElse: null)
                        ?.value ??
                    "",
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
              ),
              Icon(
                CupertinoIcons.right_chevron,
                color: Theme.of(context).accentColor,
              ),
            ],
          ),
          onPressed: () => Navigator.pushNamed(
            context,
            CategorySelectPage.routeNamed,
            arguments: vm.categoryFilter,
          ).then((categoryId) {
            vm.companyFilterCategoryAction(categoryId);
          }),
        ));
      },
    );
  }
}

class _ViewModel {
  final void Function(int category) companyFilterCategoryAction;
  final int categoryFilter;
  final List<Category> categories;

  _ViewModel({
    this.categoryFilter,
    this.categories,
    this.companyFilterCategoryAction,
  });

  static _ViewModel fromState(Store<AppState> store) {
    return _ViewModel(
      companyFilterCategoryAction: (category) =>
          store.dispatch(CompanyFilterCategoryAction(category)),
      categories: store.state.selectCompanyViewModel.categories,
      categoryFilter: store.state.selectCompanyViewModel.categoryFilter,
    );
  }

  @override
  int get hashCode => categoryFilter.hashCode ^ categories.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel &&
          runtimeType == other.runtimeType &&
          categories == other.categories &&
          categoryFilter == other.categoryFilter;
}
