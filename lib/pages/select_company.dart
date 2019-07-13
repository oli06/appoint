import 'package:appoint/actions/companies_action.dart';
import 'package:appoint/models/app_state.dart';
import 'package:appoint/models/company.dart';
import 'package:appoint/view_models/select_company_vm.dart';
import 'package:appoint/widgets/company_list.dart';
import 'package:appoint/widgets/company_tile.dart';
import 'package:appoint/widgets/dropdown/select.dart';
import 'package:appoint/widgets/navBar.dart';
import 'package:flutter/material.dart';
import 'package:direct_select_flutter/direct_select_container.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class SelectCompany extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SelectCompanyState();
  }
}

class SelectCompanyState extends State<SelectCompany>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      onInit: (store) {
        Function update = () => store.dispatch(
            UpdateCompanyVisibilityFilterAction(
                CompanyVisibilityFilter.values[_controller.index]));
        _controller.index = store
            .state 
            .selectCompanyViewModel
            .companyVisibilityFilter
            .index; //initial value comes from the redux store
        _controller.addListener(
            update); //if there is a new selection of the tabView, it store.dispatch will be called
      },
      converter: (store) => _ViewModel.fromState(store),
      builder: (context, vm) => Scaffold(
            appBar: _buildNavBar(vm),
            body: SafeArea(
              bottom: false,
              child: DirectSelectContainer(
                child: Padding(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: Column(
                    children: <Widget>[
                      _buildDropdown(vm),
                      Expanded(
                        child: CompanyList(
                          itemBuilder: (context, index, Company cpy) =>
                              _buildCompanyTile(cpy),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
    );
  }

  TabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TabController(vsync: this, initialIndex: 0, length: 2);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  CompanyTile _buildCompanyTile(Company cpy) {
    Function onTap = () {
      Navigator.pop(context, cpy);
    };
    return CompanyTile(
      company: cpy,
      onTap: onTap,
    );
  }

  _buildDropdown(_ViewModel vm) {
    return SelectWidget<Category>(
      dataset: Category.values,
      itemBuilder: (context, value) {
        return Text(value.toString().split(".").last); //GET ONLY ENUM VALUE
      },
      selectedIndex: vm.selectCompanyViewModel.categoryFilter.index,
      onSelectionChanged: (value, index, context) {
        vm.updateCategoryFilter(value);
      },
    );
  }

  NavBar _buildNavBar(_ViewModel vm) {
    return NavBar(
      "Neuer Termin",
      height: 99,
      leadingWidget: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () => Navigator.pop(context)),
      secondHeader: "Unternehmen auswählen",
      trailing: Container(
        height: 0,
      ),
      tabBar: tabBar(vm),
    );
  }

  Widget tabBar(_ViewModel vm) {
    return TabBar(
      indicatorColor: Color(0xff09c199),
      unselectedLabelColor: Colors.black,
      labelColor: Color(0xff09c199),
      controller: _controller,
      tabs: <Widget>[
        Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Favoriten"),
              Icon(Icons.favorite),
            ],
          ),
        ),
        Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Alle"),
              Icon(Icons.list),
            ],
          ),
        ),
      ],
    );
  }
}

class _ViewModel {
  final SelectCompanyViewModel selectCompanyViewModel;
  final Function(CompanyVisibilityFilter filter) updateFilter;
  final Function(Category category) updateCategoryFilter;

  _ViewModel({
    this.updateFilter,
    this.selectCompanyViewModel,
    this.updateCategoryFilter,
  });

  static _ViewModel fromState(Store<AppState> store) {
    return _ViewModel(
      updateFilter: (CompanyVisibilityFilter filter) => store.dispatch(
            UpdateCompanyVisibilityFilterAction(filter),
          ),
      selectCompanyViewModel: store.state.selectCompanyViewModel,
      updateCategoryFilter: (Category category) => store.dispatch(
            UpdateCategoryFilterAction(
              (category),
            ),
          ),
    );
  }
}
