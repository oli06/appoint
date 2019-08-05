import 'package:appoint/actions/companies_action.dart';
import 'package:appoint/middleware/search_epic.dart';
import 'package:appoint/models/app_state.dart';
import 'package:appoint/models/company.dart';
import 'package:appoint/view_models/select_company_vm.dart';
import 'package:appoint/selectors/selectors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:location/location.dart';
import 'package:redux/redux.dart';

class CompanyList extends StatefulWidget {
  final Widget Function(BuildContext context, int index, Company cpy)
      itemBuilder;
  final bool filterWithRange;
  final bool filterWithVisibility;

  CompanyList(
      {@required this.itemBuilder,
      this.filterWithRange = false,
      this.filterWithVisibility = false});

  @override
  _CompanyListState createState() => _CompanyListState();
}

class _CompanyListState extends State<CompanyList> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
        onInit: (Store<AppState> store) => store.dispatch(
            CompanySearchAction(store.state.selectCompanyViewModel.filters)),
        converter: _ViewModel.fromStore,
        builder: (context, vm) {
          return Stack(
            alignment: AlignmentDirectional.topCenter,
            children: <Widget>[
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: vm.selectCompanyViewModel.companySearchState.isLoading
                    ? 1.0
                    : 0.0,
                child: _buildLoading(),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity:
                    !vm.selectCompanyViewModel.companySearchState.isLoading &&
                                vm.selectCompanyViewModel.companySearchState
                                        ?.searchResults?.length ==
                                    0 ??
                            false
                        ? 1.0
                        : 0.0,
                child: _buildEmptyList(),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: vm.selectCompanyViewModel.companySearchState
                            .searchResults !=
                        null
                    ? 1.0
                    : 0.0,
                child: _buildCompanyList(
                    vm.selectCompanyViewModel.companySearchState.searchResults),
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
            "Keine Unternehmen gefunden. Versuchen Sie es mit anderen Sucheinstellungen",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w200),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyList(List<Company> companies) {
/*     if (companies.length == 0) {
      return _buildEmptyList();
    } */

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
              return widget.itemBuilder(context, index, companies[index]);
            },
          ),
        ),
      ),
    );
  }
}

class _ViewModel {
  final SelectCompanyViewModel selectCompanyViewModel;
  final List<int> companyFavorites;
  final LocationData userLocation;

  _ViewModel({
    @required this.selectCompanyViewModel,
    this.companyFavorites,
    this.userLocation,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      selectCompanyViewModel: store.state.selectCompanyViewModel,
      companyFavorites: store.state.userViewModel.user.favorites,
      userLocation: store.state.userViewModel.currentLocation,
    );
  }
}
