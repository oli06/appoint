import 'package:appoint/actions/user_action.dart';
import 'package:appoint/models/appoint.dart';
import 'package:appoint/pages/add_appoint.dart';
import 'package:appoint/utils/ios_url_scheme.dart';
import 'package:appoint/utils/parse.dart';
import 'package:appoint/widgets/company_tile.dart';
import 'package:appoint/widgets/icon_circle_gradient.dart';
import 'package:appoint/widgets/navBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:appoint/models/app_state.dart';
import 'package:location/location.dart';
import 'package:redux/redux.dart' as redux;

class AppointmentDetails extends StatelessWidget {
  static const routeName = '/appointment_details';

  const AppointmentDetails({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();

    final Appoint appointment = ModalRoute.of(context).settings.arguments;
    bool eventIsActive = false;
    String eventDuration = "";
    if (appointment.period.start.isBefore(DateTime.now())) {
      eventIsActive = true;
    } else {
      eventDuration = Parse.convertDateDifferenceToReadable(
          DateTime.now(), appointment.period.start);
    }

    return Scaffold(
      appBar: _buildNavBar(context),
      key: _scaffoldKey,
      body: Padding(
        padding: const EdgeInsets.only(top: 8, left: 8, right: 8),
        child: CupertinoScrollbar(
          child: ListView(
            children: <Widget>[
              Card(
                elevation: 1,
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(15),
                        child: Text(
                          appointment.title,
                          textAlign: TextAlign.start,
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      _buildDivider(),
                      CompanyTile(
                        company: appointment.company,
                        isStatic: true,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Card(
                elevation: 1,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      _buildPeriodTile(
                          appointment, eventIsActive, eventDuration),
                      if (appointment.description != null &&
                          appointment.description.isNotEmpty) ...[
                        _buildDivider(),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              appointment.description,
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        )
                      ],
                    ],
                  ),
                ),
              ),
              _buildActionButtons(
                  appointment, context, _scaffoldKey, eventIsActive),
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

  Padding _buildPeriodTile(
      Appoint appointment, bool eventIsActive, String eventDuration) {
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
                  eventIsActive ? "Termin aktiv" : "Termin in $eventDuration",
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  IconCircleGradient.periodIndicator(
                      appointment.period.duration.inMinutes / 60),
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

  Widget _buildActionButtons(Appoint appoint, BuildContext context,
      GlobalKey<ScaffoldState> scaffoldKey, bool isActive) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 2.0),
                  child: Icon(Icons.delete),
                ),
                Text("Absagen"),
              ],
            ),
            onPressed: isActive ? null : () {},
          ),
          StoreConnector<AppState, _ViewModel>(
            distinct: true,
            converter: (store) => _ViewModel.fromState(store),
            onInit: (store) {
              if (store.state.userViewModel.currentLocation == null) {
                store.dispatch(LoadUserLocationAction());
              }
            },
            builder: (context, vm) => CupertinoButton(
                padding: EdgeInsets.zero,
                child: Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 2.0),
                      child: Icon(Icons.map),
                    ),
                    Text("Route"),
                  ],
                ),
                onPressed: () => UrlScheme.buildRouteCupertinoActionSheet(
                      context,
                      vm.location.latitude,
                      vm.location.longitude,
                      appoint.company.address.latitude,
                      appoint.company.address.longitude,
                    )),
          ),
          CupertinoButton(
            padding: EdgeInsets.zero,
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 2.0),
                  child: Icon(Icons.schedule),
                ),
                Text("Verschieben"),
              ],
            ),
            onPressed: isActive
                ? null
                : () => showCupertinoModalPopup(
                      context: context,
                      builder: (context) => AddAppoint(
                        isEditing: true,
                        appoint: appoint,
                        key: scaffoldKey,
                      ),
                    ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavBar(BuildContext context) {
    return NavBar(
      "Details",
      height: 57,
      leadingWidget: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          }),
    );
  }
}

class _ViewModel {
  final LocationData location;
  final Function requestUserLocation;

  _ViewModel({this.location, this.requestUserLocation});

  static _ViewModel fromState(redux.Store<AppState> store) {
    return _ViewModel(
        location: store.state.userViewModel.currentLocation,
        requestUserLocation: () => store.dispatch(LoadUserLocationAction()));
  }
}
