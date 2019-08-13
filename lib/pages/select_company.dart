import 'package:appoint/actions/companies_action.dart';
import 'package:appoint/containers/company_category_button.dart';
import 'package:appoint/containers/company_range_slider.dart';
import 'package:appoint/containers/company_search_field.dart';
import 'package:appoint/enums/enums.dart';
import 'package:appoint/models/app_state.dart';
import 'package:appoint/models/company.dart';
import 'package:appoint/utils/logger.dart';
import 'package:appoint/widgets/company_list.dart';
import 'package:appoint/widgets/company_tile.dart';
import 'package:appoint/widgets/navBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:logger/logger.dart';

class SelectCompany extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SelectCompanyState();
  }
}

class SelectCompanyState extends State<SelectCompany>
    with TickerProviderStateMixin {
  final Logger _logger = getLogger("SelectCompany");

  @override
  Widget build(BuildContext context) {
    _logger.d("build");
    final store = StoreProvider.of<AppState>(context);
    _logger.d("onInit");
    _controller.index = store
        .state
        .selectCompanyViewModel
        .companyVisibilityFilter
        .index; //initial value comes from the redux store
    _controller.addListener(
      () {
        //fix listener getting called twice: https://github.com/flutter/flutter/issues/13848
        if (_controller.indexIsChanging) {
          _logger.d("update visibility index to: ${_controller.index}");

          store.dispatch(CompanyFilterVisibilityAction(
              CompanyVisibilityFilter.values[_controller.index]));
        }
      },
    );
    return Scaffold(
        appBar: _buildNavBar(),
        body: GestureDetector(
          //gesture detector to hide keyboard if user clicks somewhere on the screen
          onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
          behavior: HitTestBehavior.opaque,
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: <Widget>[
                  //_buildSearchField(vm),
                  CompanySearchField(),
                  CompanyCategoryButton(),
                  _buildRangeAndMapButton(),
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
        ) /* ;
        },
      ), */
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

  Widget _buildCompanyTile(Company cpy) {
    return StoreConnector<AppState, VoidCallback>(
        rebuildOnChange: false,
        distinct: true,
        converter: (store) {
          return () => store.dispatch(ResetCompanyNameSearchFilterAction());
        },
        builder: (context, callback) {
          Function onTap = () {
            Navigator.pop(context, cpy);
            callback();
          };

          return CompanyTile(
            isStatic: true,
            company: cpy,
            onTap: onTap,
          );
        });
  }

  Row _buildRangeAndMapButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        CompanyRangeSlider(),
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
          onPressed: () {},
        ),
      ],
    );
  }

  NavBar _buildNavBar() {
    _logger.d("navBar build");

    return NavBar(
      "Neuer Termin",
      height: 99,
      leadingWidget: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
          ),
          onPressed: () => Navigator.pop(context)),
      secondHeader: "Unternehmen auswählen",
      tabBar: tabBar(),
    );
  }

  Widget tabBar() {
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
