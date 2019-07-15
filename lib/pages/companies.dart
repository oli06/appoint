import 'package:appoint/actions/companies_action.dart';
import 'package:appoint/actions/user_action.dart';
import 'package:appoint/assets/company_icons_icons.dart';
import 'package:appoint/models/app_state.dart';
import 'package:appoint/models/company.dart';
import 'package:appoint/pages/company_details.dart';
import 'package:appoint/view_models/select_company_vm.dart';
import 'package:appoint/widgets/company_list.dart';
import 'package:appoint/widgets/company_tile.dart';
import 'package:appoint/widgets/dropdown/select.dart';
import 'package:appoint/widgets/navBar.dart';
import 'package:direct_select_flutter/direct_select_container.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class CompanyPage extends StatefulWidget {
  @override
  _CompanyPageState createState() => _CompanyPageState();
}

class _CompanyPageState extends State<CompanyPage>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      onInit: (store) {
        if (store.state.userViewModel.currentLocation == null) {
          store.dispatch(LoadUserLocationAction());
        }
      },
      converter: (store) => _ViewModel.fromState(store),
      builder: (context, vm) => Scaffold(
        appBar: _buildNavBar(vm),
        body: SafeArea(
          bottom: false,
          child: DirectSelectContainer(
            child: Column(
              children: <Widget>[
                _buildDropdown(vm),
                _buildRangeAndMapButton(vm),
                Expanded(
                  child: _buildCompanyList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row _buildRangeAndMapButton(_ViewModel vm) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            Slider(
              activeColor: Color(0xff09c199),
              value: vm.selectCompanyViewModel.rangeFilter,
              min: 1.0,
              max: 50.0,
              onChanged: (double newValue) => vm.updateRangeFilter(newValue),
            ),
            Text("${vm.selectCompanyViewModel.rangeFilter.toInt()} km"),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: FlatButton(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("Karte"),
                Padding(
                  padding: const EdgeInsets.only(left: 2.0),
                  child: Icon(
                    Icons.map,
                    color: Theme.of(context).iconTheme.color,
                  ),
                ),
              ],
            ),
            onPressed: () {
              print("Change mode to map");
            },
          ),
        ),
      ],
    );
  }

  _buildDropdown(_ViewModel vm) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0),
      child: SelectWidget<Category>(
        dataset: Category.values,
        itemBuilder: (context, value) {
          return Text(value.toString().split('.').last);
        },
        selectedIndex: vm.selectCompanyViewModel.categoryFilter.index,
        onSelectionChanged: (value, index, context) =>
            vm.updateCategoryFilter(value),
      ),
    );
  }

  NavBar _buildNavBar(_ViewModel vm) {
    return NavBar(
      "Unternehmen",
      height: 99,
      leadingWidget: Container(
        child: Icon(
          CompanyIcons.account_balance,
        ),
        padding: EdgeInsets.only(left: 10.0),
      ),
      tabBar: Padding(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
        child: Column(
          children: <Widget>[
            Container(
              child: CupertinoTextField(
                textInputAction: TextInputAction.search,
                clearButtonMode: OverlayVisibilityMode.editing,
                maxLines: 1,
                placeholder: "Suchen",
                prefix: Icon(Icons.search),
                prefixMode: OverlayVisibilityMode.notEditing,
                autocorrect: false,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompanyList() {
    return CompanyList(
      itemBuilder: (context, index, cpy) {
        return CompanyTile(
          company: cpy,
          onTap: () => Navigator.pushNamed(context, CompanyDetails.routeName,
              arguments: cpy),
        );
      },
    );
  }
}

class _ViewModel {
  final SelectCompanyViewModel selectCompanyViewModel;
  final Function(Category category) updateCategoryFilter;
  final Function(double value) updateRangeFilter;

  _ViewModel({
    this.selectCompanyViewModel,
    this.updateCategoryFilter,
    this.updateRangeFilter,
  });

  static _ViewModel fromState(Store<AppState> store) {
    return _ViewModel(
      selectCompanyViewModel: store.state.selectCompanyViewModel,
      updateCategoryFilter: (Category category) => store.dispatch(
        UpdateCategoryFilterAction((category)),
      ),
      updateRangeFilter: (double value) =>
          store.dispatch(UpdateRangeFilterAction(value)),
    );
  }
}
