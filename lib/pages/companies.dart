import 'package:appoint/assets/company_icons_icons.dart';
import 'package:appoint/widgets/company_list.dart';
import 'package:appoint/widgets/company_tile.dart';
import 'package:appoint/widgets/navBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CompanyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavBar(
        "Unternehmen",
        height: 57,
        leadingWidget: Container(
          child: Icon(
            CompanyIcons.account_balance,
          ),
          padding: EdgeInsets.only(left: 10.0),
        ),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: <Widget>[
            Expanded(
              child: _buildCompanyList(),
            ),
          ],
        ),
      ),
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
