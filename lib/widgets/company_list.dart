import 'package:appoint/actions/companies_action.dart';
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
        onInit: (Store<AppState> store) =>
            store.dispatch(LoadCompaniesAction()),
        converter: _ViewModel.fromStore,
        builder: (context, vm) {
          if (vm.selectCompanyViewModel.isLoading) {
            return _buildLoading();
          } else if (vm.selectCompanyViewModel.companies.length == 0) {
            return _buildEmptyList();
          } else
            return _buildCompanyList(
              companiesRangeFilter(
                  companiesCategoryFilterSelector(
                      companiesVisibilityFilterSelector(
                        vm.selectCompanyViewModel.companies,
                        widget.filterWithVisibility
                            ? vm.selectCompanyViewModel.companyVisibilityFilter
                            : CompanyVisibilityFilter.all,
                        vm.companyFavorites,
                      ),
                      vm.selectCompanyViewModel.categoryFilter),
                  widget.filterWithRange
                      ? vm.selectCompanyViewModel.rangeFilter
                      : null,
                  vm.userLocation.latitude,
                  vm.userLocation.longitude),
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
    print(companies.length);
    //TODO: FIXME: test, if hideKeyboard on scroll wirklich gescheit funktionert

    return NotificationListener(
      onNotification: (t) {
        if (t is UserScrollNotification) {
          FocusScope.of(context).requestFocus(FocusNode());
        }
      },
      child: Container(
        child: CupertinoScrollbar(
          child: ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: companies.length,
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
      companyFavorites: store.state.userViewModel.user.companyFavorites,
      userLocation: store.state.userViewModel.currentLocation,
    );
  }
}
