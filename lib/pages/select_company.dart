import 'package:appoint/actions/companies_action.dart';
import 'package:appoint/models/app_state.dart';
import 'package:appoint/models/company.dart';
import 'package:appoint/pages/category_select.dart';
import 'package:appoint/view_models/select_company_vm.dart';
import 'package:appoint/widgets/company_list.dart';
import 'package:appoint/widgets/company_tile.dart';
import 'package:appoint/widgets/navBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: <Widget>[
                _buildSearchField(),
                _buildCategorySelect(vm),
                _buildRangeAndMapButton(vm),
                Expanded(
                  child: CompanyList(
                    filterWithVisibility: true,
                    itemBuilder: (context, index, Company cpy) =>
                        _buildCompanyTile(cpy),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
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
      isStatic: true,
      company: cpy,
      onTap: onTap,
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
        FlatButton(
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
      ],
    );
  }

  _buildCategorySelect(_ViewModel vm) {
    return Container(
        child: FlatButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              "Kategorie",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
            ),
          ),
          Text(
            vm.selectCompanyViewModel.categories
                .firstWhere(
                    (c) => c.id == vm.selectCompanyViewModel.categoryFilter)
                .value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
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
        arguments: vm.selectCompanyViewModel.categoryFilter,
      ).then((categoryId) {
        vm.updateCategoryFilter(categoryId);
      }),
    ));

    /*
    return SelectWidget<Category>(
      dataset: vm.selectCompanyViewModel.categories,
      itemBuilder: (context, category) {
        return Text(category.value);
      },
      selectedIndex: vm.selectCompanyViewModel.categories
          .indexWhere((c) => c.id == vm.selectCompanyViewModel.categoryFilter),
      onSelectionChanged: (value, index, context) {
        vm.updateCategoryFilter(value.id);
      },
    );*/
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
              Text("Alle"),
              Icon(Icons.list),
            ],
          ),
        ),
        Tab(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Favoriten"),
              Icon(Icons.favorite),
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
  final Function(int categoryId) updateCategoryFilter;
  final Function(double value) updateRangeFilter;

  _ViewModel({
    this.updateFilter,
    this.selectCompanyViewModel,
    this.updateCategoryFilter,
    this.updateRangeFilter,
  });

  static _ViewModel fromState(Store<AppState> store) {
    return _ViewModel(
      updateFilter: (CompanyVisibilityFilter filter) => store.dispatch(
        UpdateCompanyVisibilityFilterAction(filter),
      ),
      selectCompanyViewModel: store.state.selectCompanyViewModel,
      updateCategoryFilter: (int categoryId) => store.dispatch(
        UpdateCategoryFilterAction(
          (categoryId),
        ),
      ),
      updateRangeFilter: (double value) =>
          store.dispatch(UpdateRangeFilterAction(value)),
    );
  }
}
