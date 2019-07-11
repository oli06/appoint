import 'package:appoint/models/appoint.dart';
import 'package:appoint/utils/parse.dart';
import 'package:appoint/widgets/company_tile.dart';
import 'package:appoint/widgets/navBar.dart';
import 'package:appoint/widgets/period_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppointmentDetails extends StatelessWidget {
  static const routeName = '/appointment_details';

  const AppointmentDetails({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Appoint appointment = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: _buildNavBar(),
      body: Padding(
        padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
        child: CupertinoScrollbar(
          child: ListView(
            children: <Widget>[
              Card(
                elevation: 2,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(15),
                        child: Text(
                          appointment.title,
                          textAlign: TextAlign.end,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      _buildDivider(),
                      CompanyTile(
                        company: appointment.company,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      _buildPeriodTile(appointment),
                      if (appointment.description != null && appointment.description.isNotEmpty) ...[
                        _buildDivider(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            appointment.description,
                            style: TextStyle(fontSize: 16),
                          ),
                        )
                      ],
                    ],
                  ),
                ),
              ),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Container _buildDivider() {
    return Container(
      padding: EdgeInsets.only(
        left: 15,
        right: 15,
      ),
      child: Divider(
        height: 1,
      ),
    );
  }

  Padding _buildPeriodTile(Appoint appointment) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  Parse.dateWithWeekday.format(appointment.period.start),
                  style: TextStyle(fontSize: 17),
                ),
                Text(
                    "in ${Parse.convertDateDifferenceToReadable(DateTime.now(), appointment.period.start)}"),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  PeriodBar(
                    period: appointment.period,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${Parse.hoursWithMinutes.format(appointment.period.start.toUtc())} - ${Parse.hoursWithMinutes.format(appointment.period.getPeriodEnd().toUtc())}",
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        CupertinoButton(
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Icon(Icons.delete),
              ),
              Text("Absagen"),
            ],
          ),
          onPressed: () {},
        ),
        CupertinoButton(
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Icon(Icons.map),
              ),
              Text("Route"),
            ],
          ),
          onPressed: () {},
        ),
        CupertinoButton(
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(2.0),
                child: Icon(Icons.schedule),
              ),
              Text("Verschieben"),
            ],
          ),
          onPressed: () {},
        ),
      ],
    );
  }

  Widget _buildNavBar() {
    return NavBar(
      "Details",
      height: 57,
      leadingWidget: CupertinoNavigationBarBackButton(
        previousPageTitle: "Termine",
      ),
      trailing: Container(height: 0, width: 0,),
    );
  }
}
