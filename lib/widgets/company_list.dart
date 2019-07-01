import 'package:appoint/base/base_view.dart';
import 'package:appoint/model/company.dart';
import 'package:appoint/viewmodels/company_select_model.dart';
import 'package:appoint/viewmodels/create_appoint_model.dart';
import 'package:appoint/widgets/company_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CompanyList extends StatelessWidget {

  //final CreateAppointModel model = locator<CreateAppointModel>();
  final CreateAppointModel createAppointModel;

CompanyList({this.createAppointModel});

  @override
  Widget build(BuildContext context) {
    return BaseView<CompanySelectModel>(
      onModelReady: (model) => model.getCompanies(),
      builder: (context, model, child) {
        if (model.companies == null) {
          return _buildLoading();
        } else if (model.companies.length == 0) {
          return _buildEmptyList();
        } else
          return _buildCompanyList(model.companies);
      },
    );
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(),
          SizedBox(
            height: 15,
          ),
          Text(
            "Unternehmen werden geladen...",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w200,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildEmptyList() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Keine Unternehmen gefunden. Versuchen Sie es mit anderen Sucheinstellungen",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w200),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCompanyList(List<Company> companies) {
    return Container(
      child: ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        itemCount: companies.length,
        itemBuilder: (context, index) {
          Company cpy = companies[index];
          Function onTap = () {
            createAppointModel.setCompany(cpy);
            Navigator.pop(context);
          };
          return CompanyTile(
            company: cpy,
            onTap: onTap,
          );
        },
      ),
    );
  }
}
