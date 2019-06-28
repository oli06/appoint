import 'package:appoint/base/navBar.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: <Widget>[
          buildNavBar(context),
          _getLowerLayer(),
          /*         FlatButton(
            child: Text("press"),
            onPressed: () => showCupertinoModalPopup(
                  context: context,
                  builder: (context) => SelectCompany(),
                ),
          ) */
        ],
      )),
    );
  }

  NavBar buildNavBar(BuildContext context) {
    return NavBar(
      "Neuer Termin",
      IconButton(
        icon: Icon(Icons.close),
        onPressed: () => Navigator.pop(context),
      ),
      endingWidget: CupertinoButton(
        padding: EdgeInsets.zero,
        child: Text("Erstellen"),
        onPressed: () {},
      ),
    );
  }

  Widget _firstCard(BuildContext context) {
    return Container(
      child: Card(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: 40,
                    padding: EdgeInsets.only(
                      left: 15,
                      right: 15,
                    ),
                    child: Align(
                      child: TextField(
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
            Container(
              height: 40,
              child: FlatButton(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Unternehmen auswählen...",
                    ),
                    Icon(
                      CupertinoIcons.getIconData(0xf3d0),
                      color: Colors.black,
                    ),
                  ],
                ),
                onPressed: () => showCupertinoModalPopup(
                      context: context,
                      builder: (context) => SelectCompany(),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getLowerLayer() {
    return Form(
      key: _appointFormKey,
      child: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          _firstCard(context),
          SizedBox(
            height: 20,
          ),
          Card(
            child: Container(
              padding: EdgeInsets.only(
                left: 15,
                right: 15,
              ),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
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
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 160,
                      child: Divider(
                        height: 1,
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
                          onPressed: () {
                            showCupertinoModalPopup(context: context, builder: (context) {
                              SelectTimespan(isDateMode: true,);
                            });
                          },
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
                          onPressed: () {
                                                        showCupertinoModalPopup(context: context, builder: (context) {
                              SelectTimespan(isDateMode: false,);
                            });
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}