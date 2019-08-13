import 'package:appoint/actions/companies_action.dart';
import 'package:appoint/enums/enums.dart';
import 'package:appoint/middleware/search_epic.dart';
import 'package:appoint/models/app_state.dart';
import 'package:appoint/models/company.dart';
import 'package:appoint/selectors/selectors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class CompanyList extends StatelessWidget {
  final Widget Function(BuildContext context, int index, Company cpy)
      itemBuilder;

  CompanyList({
    @required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
        distinct: true,
        onInit: (Store<AppState> store) => store.dispatch(
            CompanyFilterCategoryAction(
                store.state.selectCompanyViewModel.categoryFilter)),
        converter: (store) => _ViewModel.fromState(store),
        builder: (context, vm) {
          return Stack(
            alignment: AlignmentDirectional.topCenter,
            children: <Widget>[
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: vm.companySearchState.isLoading ? 1.0 : 0.0,
                child: _buildLoading(),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: !vm.companySearchState.isLoading &&
                            companiesVisibilityFilterSelector(
                                        vm.companySearchState?.searchResults,
                                        vm.filter,
                                        vm.userFavorites)
                                    .length ==
                                0 ??
                        false
                    ? 1.0
                    : 0.0,
                child: _buildEmptyList(),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity:
                    vm.companySearchState.searchResults != null ? 1.0 : 0.0,
                child: _buildCompanyList(
                  companiesVisibilityFilterSelector(
                      vm.companySearchState.searchResults,
                      vm.filter,
                      vm.userFavorites),
                  context,
                ),
              ),
            ],
          );
        });
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          SizedBox(
            height: 15,
          ),
          Text(
            "Unternehmen werden geladen...",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w200,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildEmptyList() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Keine Unternehmen gefunden. Versuche es mit anderen Sucheinstellungen",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w200),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyList(List<Company> companies, BuildContext context) {
    return NotificationListener(
      onNotification: (t) {
        if (t is UserScrollNotification) {
          FocusScope.of(context).requestFocus(FocusNode());
        }
      },
      child: Container(
        child: CupertinoScrollbar(
          child: ListView.separated(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: companies.length,
            separatorBuilder: (context, index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Divider(height: 1),
            ),
            itemBuilder: (context, index) {
              return itemBuilder(context, index, companies[index]);
            },
          ),
        ),
      ),
    );
  }
}

class _ViewModel {
  final CompanySearchState companySearchState;
  final CompanyVisibilityFilter filter;
  final List<int> userFavorites;

  _ViewModel({
    this.companySearchState,
    this.filter,
    this.userFavorites,
  });

  static _ViewModel fromState(Store<AppState> store) {
    return _ViewModel(
      companySearchState: store.state.selectCompanyViewModel.companySearchState,
      filter: store.state.selectCompanyViewModel.companyVisibilityFilter,
      userFavorites: store.state.userViewModel.user.favorites,
    );
  }

  @override
  int get hashCode =>
      companySearchState.hashCode ^ filter.hashCode ^ userFavorites.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel &&
          runtimeType == other.runtimeType &&
          companySearchState == other.companySearchState &&
          userFavorites == other.userFavorites &&
          filter == other.filter;
}
