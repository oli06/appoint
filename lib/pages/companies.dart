import 'package:appoint/widgets/company_list.dart';
import 'package:appoint/widgets/company_tile.dart';
import 'package:appoint/widgets/navBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CompanyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          bottom: false,
          child: Column(
            children: <Widget>[
              NavBar(
                "Unternehmen",
                leadingWidget: Container(
                  child: Icon(
                    CupertinoIcons.getIconData(0xf3ed),
                  ),
                  padding: EdgeInsets.only(left: 10.0),
                ),
              ),
              Expanded(
                child: _buildCompanyList(),
              ),
            ],
          )),
    );
  }

  Widget _buildCompanyList() {
    return CompanyList(
      itemBuilder: (context, index, cpy) {
        return CompanyTile(
          company: cpy,
          onTap: () {},
        );
      },
    );
  }
}
