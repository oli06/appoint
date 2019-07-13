import 'package:appoint/actions/appointments_action.dart';
import 'package:appoint/models/app_state.dart';
import 'package:appoint/models/appoint.dart';
import 'package:appoint/models/day.dart';
import 'package:appoint/pages/add_appoint.dart';
import 'package:appoint/pages/appointment_details.dart';
import 'package:appoint/pages/profile.dart';
import 'package:appoint/selectors/selectors.dart';
import 'package:appoint/utils/parse.dart';
import 'package:appoint/view_models/appointments_vm.dart';
import 'package:appoint/widgets/appointment_tile.dart';
import 'package:appoint/widgets/list_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:appoint/widgets/navBar.dart';
import 'package:badges/badges.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

class AppointmentPage extends StatefulWidget {
  @override
  _AppointmentPageState createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel.fromState(store),
      onInit: (store) => store.dispatch(LoadAppointmentsAction()),
      builder: (context, vm) => Scaffold(
            appBar: _buildNavBar(),
            body: vm.appointmentsViewModel.isLoading
                ? _buildLoading()
                : vm.appointmentsViewModel.appointments.length == 0
                    ? _buildEmptyList()
                    : _buildAppointmentsList(vm),
          ),
    );
  }

  final _scrollController = ScrollController();
  List<_ListHeader> listElements = [];
  Widget _buildAppointmentsList(_ViewModel vm) {
    final List<Day<Appoint>> days =
        groupAppointmentsByDate(vm.appointmentsViewModel.appointments);
    
    //filter next Appointment
    final Appoint upcomingAppointment = days[0].events[0];
    days[0].events.removeAt(0);
    if (days[0].events.length == 0) {
      days.remove(0);
    }
    
    days.forEach((d) => listElements.add(
        _ListHeader(childrenCount: d.events.length, value: d.date.toUtc())));

    final List<Widget> slivers = List<Widget>();
    days.asMap().forEach((index, day) =>
        slivers.addAll(_buildHeaderBuilderLists(context, index, 1, day)));
    return Column(
      children: <Widget>[
        _buildUpcomingEventDescription(upcomingAppointment),
        _buildUpcomingAppointment(upcomingAppointment),
        Expanded(
          child: CupertinoScrollbar(
            child: CustomScrollView(
              shrinkWrap: true,
              controller: _scrollController,
              slivers: slivers,
            ),
          ),
        ),
      ],
    );
  }

  Padding _buildUpcomingEventDescription(Appoint upcomingAppointment) {
    return Padding(
        padding: const EdgeInsets.only(left: 8.0, right: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text("Termin in ${Parse.convertDateDifferenceToReadable(DateTime.now(), upcomingAppointment.period.start)}:", style: TextStyle(fontSize: 18),),
            CupertinoButton(
              padding: EdgeInsets.zero,
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
          ],
        ),
      );
  }

  Padding _buildUpcomingAppointment(Appoint upcomingAppointment) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 0, 8, 8),
      child: GestureDetector(
        onTap: () => Navigator.pushNamed(
                      context, AppointmentDetails.routeName,
                      arguments: upcomingAppointment),
        child: Container(
          padding: EdgeInsets.all(4.0),
          height: 68,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(5),
            gradient: LinearGradient(colors: [
              Color(0xff6dd7c7).withOpacity(0.8),
              Color(0xff188e9b).withOpacity(0.8)
            ], begin: Alignment.topLeft, end: Alignment.bottomRight),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        upcomingAppointment.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Color(0xff333f52)),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              "${Parse.hoursWithMinutes.format(upcomingAppointment.period.start.toUtc())} - ${Parse.hoursWithMinutes.format(upcomingAppointment.period.getPeriodEnd().toUtc())}",
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                          Text(upcomingAppointment.company.category
                              .toString()
                              .split(".")
                              .last),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(upcomingAppointment.company.name),
                          Text(upcomingAppointment.company.address
                              .toCityString()),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildHeaderBuilderLists(
      BuildContext context, int firstIndex, int count, Day<Appoint> day) {
    return List.generate(count, (sliverIndex) {
      sliverIndex += firstIndex;
      return new SliverStickyHeaderBuilder(
        builder: (context, state) => AnimatedListHeader(
              onTap: () => listHeaderTap(day),
              start: day.date,
              state: state,
            ),
        sliver: new SliverList(
          delegate: new SliverChildBuilderDelegate(
            (context, i) => AppointmentTile(
                  appoint: day.events[i],
                  onTap: () => Navigator.pushNamed(
                      context, AppointmentDetails.routeName,
                      arguments: day.events[i]),
                ),
            childCount: day.events.length,
          ),
        ),
      );
    });
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
            "Termine werden geladen...",
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
            "Bisher haben Sie noch keine Termine vereinbart.",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w200),
            textAlign: TextAlign.center,
          ),
          FlatButton(
            child: Text("Jetzt Termin vereinbaren"),
            onPressed: () => showCupertinoModalPopup(
                  context: context,
                  builder: (BuildContext context) =>
                      AddAppoint(isEditing: false),
                ),
          ),
        ],
      ),
    );
  }

  NavBar _buildNavBar() {
    return NavBar(
      "Termine",
      height: 57,
      leadingWidget: Container(
        padding: EdgeInsets.only(left: 10.0),
        child: Icon(
          CupertinoIcons.getIconData(0xf2d1),
        ),
      ),
      trailing: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Badge(
            badgeColor: Color(0xff09c199),
            animationType: BadgeAnimationType.scale,
            position: BadgePosition.topRight(top: 0, right: 0),
            badgeContent: Text("3"),
            child: IconButton(
              icon: Icon(Icons.message),
              onPressed: () {
                //Benachrichtigungspage anzeigen
              },
            ),
          ),
          IconButton(
            icon: Icon(CupertinoIcons.profile_circled),
            color: Theme.of(context).primaryColor,
            onPressed: () => showCupertinoModalPopup(
                  context: context,
                  builder: (context) => ProfilePage(),
                ),
          ),
        ],
      ),
    );
  }

  void listHeaderTap(Day day) {
    DatePicker.showDatePicker(
      context,
      minDateTime: DateTime.now(),
      initialDateTime: day.date,
      dateFormat: "dd-MM-yyyy",
      pickerTheme: DateTimePickerTheme(
          cancel: Text(
            "Abbrechen",
          ),
          confirm: Text(
            "Auswählen",
            style: TextStyle(color: Color(0xff1991eb)),
          )),
      onConfirm: (date, _) {
        //show selection on top of the list --> scroll there
        final destinationPosition =
            _ListHeader.calculateDistance(listElements, date);
        if (destinationPosition == -1) {
          final scaffold = Scaffold.of(context);
          scaffold.showSnackBar(
            SnackBar(
              content: const Text('Datum nicht gefunden'),
              action: SnackBarAction(
                  label: 'OK', onPressed: scaffold.hideCurrentSnackBar),
            ),
          );
        } else if (destinationPosition > 0) {
          _scrollController.animateTo(destinationPosition,
              duration: Duration(milliseconds: 200), curve: Curves.ease);
        }
      },
    );
  }
}

class _ViewModel {
  final AppointmentsViewModel appointmentsViewModel;

  _ViewModel({this.appointmentsViewModel});

  static _ViewModel fromState(Store<AppState> store) {
    return _ViewModel(appointmentsViewModel: store.state.appointmentsViewModel);
  }
}

class _ListHeader {
  final int childrenCount;

  final DateTime value;

  _ListHeader({this.childrenCount, this.value});

  static double calculateDistance(
      List<_ListHeader> elements, DateTime destination) {
    final destinationIndex = elements.indexOf(elements.firstWhere(
        (e) => Parse.sameDay(e.value, destination),
        orElse: () => _ListHeader()));
    if (destinationIndex == -1) {
      return -1;
    }
    int headerCount = 0;
    int childrenCount = 0;
    for (var i = 0; i < destinationIndex; i++) {
      headerCount++;
      childrenCount += elements[i].childrenCount;
    }

    return 35 * headerCount + childrenCount * 76.0;
  }
}
