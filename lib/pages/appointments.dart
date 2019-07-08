import 'package:appoint/actions/appointments_action.dart';
import 'package:appoint/models/app_state.dart';
import 'package:appoint/models/appoint.dart';
import 'package:appoint/models/day.dart';
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

    days.forEach((d) => listElements.add(
        _ListHeader(childrenCount: d.events.length, value: d.date.toUtc())));

    final List<Widget> slivers = List<Widget>();
    days.asMap().forEach((index, day) =>
        slivers.addAll(_buildHeaderBuilderLists(context, index, 1, day)));
    return CupertinoScrollbar(
        child: CustomScrollView(
      controller: _scrollController,
      slivers: slivers,
    ));
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
            "Bisher haben Sie noch keine Termine vereinbart. \n Klicken Sie auf den + Button unten und legen Sie direkt los.",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w200),
            textAlign: TextAlign.center,
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
            onPressed: () {
              showCupertinoModalPopup(
                context: context,
                builder: (context) => ProfilePage(),
              );
            },
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
