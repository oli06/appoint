import 'package:appoint/actions/past_appointments_action.dart';
import 'package:appoint/models/app_state.dart';
import 'package:appoint/models/appoint.dart';
import 'package:appoint/models/day.dart';
import 'package:appoint/pages/appointment_details.dart';
import 'package:appoint/selectors/selectors.dart';
import 'package:appoint/utils/logger.dart';
import 'package:appoint/utils/parse.dart';
import 'package:appoint/view_models/past_appointments_vm.dart';
import 'package:appoint/widgets/appointment_tile.dart';
import 'package:appoint/widgets/list_header.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:appoint/widgets/navBar.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:location/location.dart';
import 'package:logger/logger.dart';
import 'package:redux/redux.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';

class PastAppointmentPage extends StatelessWidget {
  static final routeName = "/last_appointments";

  final Logger _logger = getLogger('last Appointments');
  final _scrollController = ScrollController();
  final List<_ListHeader> listElements = [];

  @override
  Widget build(BuildContext context) {
    _logger.d("build");
    return Scaffold(
      appBar: _buildNavBar(context),
      body: StoreConnector<AppState, _LoadingViewModel>(
        distinct: true,
        converter: (store) => _LoadingViewModel.fromState(store),
        onInit: (store) {
          _logger.d('onInit');

          store.dispatch(LoadPastAppointments());
        },
        builder: (context, vm) {
          _logger.d("build store connector _LoadingViewModel");
          return vm.isLoading
              ? _buildLoading()
              : vm.appointmentsLength == 0
                  ? _buildEmptyList(context)
                  : _buildAppointmentsList();
        },
      ),
    );
  }

  Widget _buildAppointmentsList() {
    return StoreConnector<AppState, _ViewModel>(
      converter: (store) => _ViewModel.fromState(store),
      builder: (context, vm) {
        _logger.d("build store connect _ViewModel");
        final List<Day<Appoint>> days =
            groupAppointmentsByDate(vm.appointmentsViewModel.appointments);

        days.forEach((d) => listElements.add(_ListHeader(
            childrenCount: d.events.length, value: d.date.toUtc())));

        final List<Widget> slivers = List<Widget>();
        days.asMap().forEach((index, day) => slivers.addAll(
            _buildHeaderBuilderLists(context, index, 1, day, vm.location)));

        return Column(
          children: <Widget>[
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
      },
    );
  }

  List<Widget> _buildHeaderBuilderLists(BuildContext context, int firstIndex,
      int count, Day<Appoint> day, LocationData userLocation) {
    return List.generate(count, (sliverIndex) {
      sliverIndex += firstIndex;
      return new SliverStickyHeaderBuilder(
        builder: (context, state) => AnimatedListHeader(
          onTap: () => listHeaderTap(day, context),
          start: day.date,
          state: state,
        ),
        sliver: new SliverList(
          delegate: new SliverChildBuilderDelegate(
            (context, i) => AppointmentTile(
              appoint: day.events[i],
              userLocation: userLocation,
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

  Widget _buildEmptyList(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Text(
          "Vergangene Termine werden nach 30 Tagen automatisch gelöscht",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w200),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  NavBar _buildNavBar(BuildContext context) {
    return NavBar(
      "vergangene Termine",
      secondHeader: "werden nach 30 Tagen gelöscht",
      height: 59,
      leadingWidget: IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  void listHeaderTap(Day day, BuildContext context) {
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

class _LoadingViewModel {
  final bool isLoading;
  final int appointmentsLength;

  _LoadingViewModel({
    this.isLoading,
    this.appointmentsLength,
  });

  static _LoadingViewModel fromState(Store<AppState> store) {
    return _LoadingViewModel(
      isLoading: store.state.pastAppointmentsViewModel.isLoading,
      appointmentsLength:
          store.state.pastAppointmentsViewModel.appointments?.length ?? 0,
    );
  }

  @override
  int get hashCode => isLoading.hashCode ^ appointmentsLength.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _LoadingViewModel &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          appointmentsLength == other.appointmentsLength;
}

class _ViewModel {
  final PastAppointmentsViewModel appointmentsViewModel;
  final LocationData location;

  _ViewModel({
    this.appointmentsViewModel,
    this.location,
  });

  static _ViewModel fromState(Store<AppState> store) {
    return _ViewModel(
      appointmentsViewModel: store.state.pastAppointmentsViewModel,
      location: store.state.userViewModel.currentLocation,
    );
  }

  @override
  int get hashCode => location.hashCode ^ appointmentsViewModel.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _ViewModel &&
          runtimeType == other.runtimeType &&
          location == other.location &&
          appointmentsViewModel == other.appointmentsViewModel;
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
