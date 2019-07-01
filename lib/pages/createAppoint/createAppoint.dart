import 'package:appoint/base/base_view.dart';
import 'package:appoint/base/viewstate_enum.dart';
import 'package:appoint/model/company.dart';
import 'package:appoint/viewmodels/create_appoint_model.dart';
import 'package:appoint/widgets/company_tile.dart';
import 'package:appoint/widgets/navBar.dart';
import 'package:appoint/pages/createAppoint/selectCompany.dart';
import 'package:appoint/pages/createAppoint/selectTimespan.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CreateAppoint extends StatefulWidget {
  CreateAppoint({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CreateAppointState();
  }
}

class CreateAppointState extends State<CreateAppoint>
    with SingleTickerProviderStateMixin {
  final _appointFormKey = GlobalKey<FormState>();
  bool _timespanEnabled = false;

  set timespanEnabled(bool value) {
    if (value == _timespanEnabled) {
      return;
    }

    setState(() {
      _timespanEnabled = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseView<CreateAppointModel>(
      builder: (context, model, child) => Scaffold(
            body: SafeArea(
              child: Column(
                children: <Widget>[
                  buildNavBar(context, model),
                  model.state == ViewState.Busy
                      ? _buildShowUploadingAppoint()
                      : _getLowerLayer(model),
                ],
              ),
            ),
          ),
    );
  }

  Widget _buildShowUploadingAppoint() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  NavBar buildNavBar(BuildContext context, CreateAppointModel model) {
    print("NAV BAR WURDE ERNEUT GEBAUT ");
    return NavBar(
      "Neuer Termin",
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () => Navigator.pop(context),
      ),
      endingWidget: CupertinoButton(
        padding: EdgeInsets.zero,
        child: Text(
          "Erstellen",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onPressed: model.canBeCreated() ? () {
          //ERSTELLEN MÖGLICH
        } : null,
      ),
    );
  }

  Widget _firstCard(BuildContext context, CreateAppointModel model) {
    return Container(
      child: Card(
        elevation: 2,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: 50,
                    padding: EdgeInsets.only(
                      left: 15,
                      right: 15,
                    ),
                    child: Align(
                      child: TextField(
                        onChanged: (value) {
                          model.setTitle(value);
                        },
                        onTap: () {
                          //termin textfield tapped
                        },
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration.collapsed(
                          hintText: "Termin",
                        ),
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                )
              ],
            ),
            Container(
              padding: EdgeInsets.only(
                left: 15,
                right: 15,
              ),
              child: Divider(
                height: 1,
              ),
            ),
            model.company == null ? 
            Container(
              height: 50,
              child: FlatButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      model.company == null ? "Unternehmen auswählen..." : "${model.company.name}",
                    ),
                    Icon(
                      CupertinoIcons.getIconData(0xf3d0),
                      color: Colors.black,
                    ),
                  ],
                ),
                onPressed: () => showCupertinoModalPopup(
                      context: context,
                      builder: (context) => SelectCompany(model: model,),
                    ),
              ),
            ) : CompanyTile(company: model.company, onTap: () => showCupertinoModalPopup(
                      context: context,
                      builder: (context) => SelectCompany(model: model,),
                    )),
          ],
        ),
      ),
    );
  }

  Widget _getLowerLayer(CreateAppointModel model) {
    return Form(
      key: _appointFormKey,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          _firstCard(context, model),
          SizedBox(
            height: 20,
          ),
          _secondCard(),
        ],
      ),
    );
  }

  Card _secondCard() {
    return Card(
      color: _timespanEnabled ? null : Colors.grey,
      elevation: 2,
      child: Container(
        height: 100,
        padding: EdgeInsets.only(
          left: 15,
          right: 15,
        ),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                height: 35,
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  "Zeitraum wählen",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: OutlineButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Datum"),
                        Icon(Icons.event),
                      ],
                    ),
                    onPressed: _timespanEnabled
                        ? () {
                            showCupertinoModalPopup(
                                context: context,
                                builder: (context) => SelectTimespan(
                                      isDateMode: true,
                                    ));
                          }
                        : null,
                  ),
                ),
                Expanded(
                  child: OutlineButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("Uhrzeit"),
                        Icon(Icons.watch_later),
                      ],
                    ),
                    onPressed: _timespanEnabled
                        ? () {
                            showCupertinoModalPopup(
                                context: context,
                                builder: (context) => SelectTimespan(
                                      isDateMode: false,
                                    ));
                          }
                        : null,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
