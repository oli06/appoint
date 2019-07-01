import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:appoint/widgets/navBar.dart';

class AppointmentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: <Widget>[
          NavBar(
            "Termine",
            Container(
              padding: EdgeInsets.only(left: 10.0),
              child: Icon(
                CupertinoIcons.getIconData(0xf2d1),
              ),
            ),
          ),
          Text("Appointments Page"),
        ],
      )),
    );
  }
}
