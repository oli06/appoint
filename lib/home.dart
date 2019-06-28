import 'package:appoint/base/TabBar/FABBottomAppBarItem.dart';
import 'package:appoint/pages/appointments.dart';
import 'package:appoint/pages/companies.dart';
import 'package:appoint/pages/createAppoint/createAppoint.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int _selected;

  void _selectedTab(int index) {
    setState(() {
      _selected = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: FABBottomAppBar(
        items: [
          FABBottomAppBarItem(
              iconData: CupertinoIcons.getIconData(0xf3ed),
              text: "Unternehmen"),
          FABBottomAppBarItem(
              iconData: CupertinoIcons.getIconData(0xf2d1), text: "Termine")
        ],
        centerItemText: 'Neuer Termin',
        color: Colors.blueGrey,
        selectedColor: Colors.blue,
        notchedShape: CircularNotchedRectangle(),
        onTabSelected: _selectedTab,
        selectedIndex: 1,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildFab(context),
      body: body(),
    );
  }

  Widget body() {
    return _selected == 0 ? CompanyPage() : AppointmentPage();
  }

  Widget _buildFab(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showCupertinoModalPopup(
            context: context,
            builder: (BuildContext context) => CreateAppoint());
      },
      child: Icon(Icons.add),
      elevation: 4.0,
    );
  }
}
