import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../base/navBar.dart';

class AppointmentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: <Widget>[
          NavBar(
            "Termine",
            Icon(
              CupertinoIcons.getIconData(0xf2d1),
            ),
          ),
          Text("Appointments Page"),
        ],
      )),
    );
  }
}
