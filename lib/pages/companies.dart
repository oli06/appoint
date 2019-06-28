import 'package:appoint/base/navBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CompanyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: <Widget>[
          NavBar(
            "Unternehmen",
            Container(
              child: Icon(
                CupertinoIcons.getIconData(0xf3ed),
              ),
              padding: EdgeInsets.only(left: 10.0),
            ),
          ),
          Text("unternehmens Page"),
        ],
      )),
    );
  }
}
