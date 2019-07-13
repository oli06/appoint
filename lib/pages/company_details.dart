import 'package:appoint/assets/company_icons_icons.dart';
import 'package:appoint/models/company.dart';
import 'package:appoint/utils/parse.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CompanyDetails extends StatelessWidget {
  static final routeName = "/company_details";

  const CompanyDetails({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Company company = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 200,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: false,
                title: Padding(
                  padding: EdgeInsets.zero,
                  child: Text(company.name),
                ),
                background: Image.network(
                  //TODO:
                  "https://images.pexels.com/photos/396547/pexels-photo-396547.jpeg?auto=compress&cs=tinysrgb&h=350",
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ];
        },
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    company.rating.toStringAsFixed(1),
                    style: TextStyle(color: Color(0xfff7981c), fontSize: 16),
                  ),
                  ...Parse.ratingToIconList(company.rating),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        company.category.toString().split('.').last,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                company.address.toStreetString(),
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                company.address.toCityString(),
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 5),
              GestureDetector(
                onTap: () {
                  //TODO: launch("tel:${company.phone}") PACKAGE url_launcher
                },
                child: Text(
                  company.phone,
                  style: TextStyle(color: Color(0xff1991eb), fontSize: 16),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "Geschlossen",
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
              SizedBox(height: 10),
              Text(
                company.description,
                style: TextStyle(fontSize: 16),
              ),
              _buildActionButtons(company),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(Company company) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        CupertinoButton(
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Icon(Icons.add),
              ),
              Text("Termin vereinbaren"),
            ],
          ),
          onPressed: () {},
        ),
        CupertinoButton(
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Icon(CompanyIcons.heart_empty),
              ),
              Text("Zu Favoriten"),
            ],
          ),
          onPressed: () {},
        ),

      ],
    );
  }
}
