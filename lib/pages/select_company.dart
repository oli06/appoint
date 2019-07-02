import 'package:appoint/model/company.dart';
import 'package:appoint/widgets/company_list.dart';
import 'package:appoint/widgets/company_tile.dart';
import 'package:appoint/widgets/dropdown/select.dart';
import 'package:appoint/widgets/navBar.dart';
import 'package:flutter/material.dart';
import 'package:direct_select_flutter/direct_select_container.dart';

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
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: DirectSelectContainer(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: <Widget>[
                _buildNavBar(),
                _buildDropdown(),
                _buildListHeading(),
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
    );
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

  Container _buildListHeading() {
    return Container(
      padding: EdgeInsets.all(6.0),
      alignment: Alignment.centerLeft,
      child: const Text(
        "Unternehmen",
        style: TextStyle(
          fontWeight: FontWeight.w200,
          fontSize: 18,
        ),
      ),
    );
  }

  _buildDropdown() {
    final _categories = ["Arzt", "Steuerberater", "Andere", "Friseur"];

    return SelectWidget(
      dataset: _categories,
    );
  }

  NavBar _buildNavBar() {
    return NavBar(
      "Neuer Termin",
      leadingWidget: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
        ),
        onPressed: () => Navigator.pop(context),
      ),
      secondHeader: "Unternehmen auswählen",
      endingWidget: Container(
        height: 0,
      ),
      tabBar: tabBar(),
    );
  }

  int _selectedTab = 0;

  Widget tabBar() {
    return TabBar(
      unselectedLabelColor: Colors.black,
      labelColor: Colors.blue,
      controller: TabController(vsync: this, length: 2),
      onTap: (int index) {
        if (_selectedTab == index) {
          return;
        }

        _selectedTab = index;
        print(_selectedTab);
      },
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

  int currentlySelected = 0;
  String dropdownValue = "Arzt";
}
