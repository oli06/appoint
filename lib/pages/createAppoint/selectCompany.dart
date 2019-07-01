import 'package:appoint/data/locator.dart';
import 'package:appoint/viewmodels/create_appoint_model.dart';
import 'package:appoint/widgets/company_list.dart';
import 'package:appoint/widgets/dropdown/select.dart';
import 'package:appoint/widgets/navBar.dart';
import 'package:flutter/material.dart';
import 'package:direct_select_flutter/direct_select_container.dart';
import 'package:provider/provider.dart';
class SelectCompany extends StatefulWidget {
  final CreateAppointModel model;

  SelectCompany({this.model});

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
                _buildNavBar(context),
                _buildDropdown(),
                _buildListHeading(),
                Expanded(
                  child: CompanyList(createAppointModel: widget.model,),
                ),
              ],
            ),
          ),
        ),
      ),
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

  NavBar _buildNavBar(BuildContext context) {
    return NavBar(
      "Neuer Termin",
      IconButton(
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

  /*
  Widget _selectHeader(context) {
    return Container(
      color: Colors.transparent,
      child: Container(
          padding: EdgeInsets.only(left: 5.0, right: 5.0),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.black54,
                    offset: Offset(0, 4),
                    blurRadius: 10.0)
              ],
              color: Colors.white,
              borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(15.0),
                  topRight: const Radius.circular(15.0))),
          child: Column(
            children: <Widget>[
              Center(
                heightFactor: 5,
                child: Container(
                  width: 30,
                  height: 4,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Unternehmen auswählen",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 22),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "anschließend können Sie einen Termin wählen",
                  style: TextStyle(fontSize: 12),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.topRight,
                child: DropdownButton<String>(
                  value: dropdownValue,
                  onChanged: (String newValue) {
                    setState(() {
                      dropdownValue = newValue;
                    });
                  },
                  items: <String>['Arzt', 'Steuerberater', 'Friseur', 'Andere']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              CupertinoSegmentedControl(
                children: selectable,
                groupValue: currentlySelected,
                onValueChanged: (selected) {
                  setState(() {
                    currentlySelected = selected;
                  });
                },
              ),
            ],
          )),
    );
  }
  */
}
