import 'package:appoint/actions/favorites_action.dart';
import 'package:appoint/actions/settings_action.dart';
import 'package:appoint/models/app_state.dart';
import 'package:appoint/pages/calendar_select.dart';
import 'package:appoint/utils/constants.dart';
import 'package:appoint/view_models/settings_vm.dart';
import 'package:appoint/widgets/navBar.dart';
import 'package:appoint/widgets/switch.dart';
import 'package:device_calendar/device_calendar.dart' as prefix0;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatelessWidget {
  static final routeName = "/settings";

  SettingsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      distinct: true,
      converter: (store) => _ViewModel.fromStore(store),
      onInit: (store) {
        store.dispatch(LoadFavoritesAction(store.state.userViewModel.user.id));
      },
      builder: (context, vm) => Scaffold(
        appBar: _buildNavBar(context),
        body: SafeArea(
          child: _buildSettingsList(context, vm),
        ),
      ),
    );
  }

  Widget _buildSettingsList(BuildContext context, _ViewModel vm) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          ..._buildCalendarIntegrationRow(context, vm),
          ..._buildSaveToCalendarRow(vm),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Divider(height: 1),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildCalendarIntegrationRow(
      BuildContext context, _ViewModel vm) {
    return <Widget>[
      Container(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.event,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "Kalenderintegration",
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
            PlatformSpecificSwitch(
              onChanged: (value) =>
                  calendarIntegrationChanged(value, context, vm),
              value:
                  vm.settingsViewModel.settings[kSettingsCalendarIntegration] ??
                      false,
            )
          ],
        ),
      ),
      vm.settingsViewModel.settings[kSettingsCalendarIntegration] ?? false
          ? Text(
              "Terminüberschneidungen mit dem Kalender \"${vm.settingsViewModel.settings[kSettingsCalendarName]}\" werden angezeigt",
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            )
          : Text(
              "Wenn du die Kalenderintegration aktivierst, werden Terminüberschneidungen bei der Terminerstellung beachtet und angezeigt",
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            )
    ];
  }

  List<Widget> _buildSaveToCalendarRow(_ViewModel vm) {
    return <Widget>[
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Container(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                CupertinoIcons.add,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    "In Kalender übernehmen",
                    style: TextStyle(
                        fontSize: 18,
                        color: vm.settingsViewModel
                                    .settings[kSettingsCalendarIntegration] !=
                                true
                            ? Colors.grey
                            : null),
                  ),
                ),
              ),
              PlatformSpecificSwitch(
                onChanged: vm.settingsViewModel
                            .settings[kSettingsCalendarIntegration] !=
                        true
                    ? null
                    : (value) => saveToCalendarChanged(value, vm),
                value: vm.settingsViewModel.settings[kSettingsSaveToCalendar] ??
                    false,
              )
            ],
          ),
        ),
      ),
      (vm.settingsViewModel.settings[kSettingsSaveToCalendar] ?? false) == true
          ? Text(
              "Neu erstellte Termine werden automatisch in den Kalender \"${vm.settingsViewModel.settings[kSettingsCalendarName]}\" übertragen.",
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            )
          : Text(
              "Aktiviere die Funktion, damit neu erstellte Termine automatisch in deinen Kalender übertragen werden.",
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
    ];
  }

  void saveToCalendarChanged(bool value, _ViewModel vm) async {
    final sharedPreferencesInstance = await SharedPreferences.getInstance();

    vm.updateValueForKey(kSettingsSaveToCalendar, value);

    sharedPreferencesInstance.setBool(kSettingsSaveToCalendar, value);
  }

  void calendarIntegrationChanged(
      bool value, BuildContext context, _ViewModel vm) async {
    final sharedPreferencesInstance = await SharedPreferences.getInstance();

    if (!value) {
      //disable calendar integration
      vm.updateValueForKey(kSettingsCalendarIntegration, false);
      sharedPreferencesInstance.setBool(kSettingsCalendarIntegration, false);

      return;
    }

    Navigator.pushNamed(context, CalendarSelectPage.routeNamed)
        .then((calendar) {
      final calendarInstance = calendar as prefix0.Calendar;

      if (calendar == null) {
        print("no calendar selected");
        return;
      }

      //enable calendar integration
      vm.updateValueForKey(kSettingsCalendarId, calendarInstance.id);
      vm.updateValueForKey(kSettingsCalendarIntegration, true);
      vm.updateValueForKey(kSettingsCalendarName, calendarInstance.name);

      sharedPreferencesInstance.setBool(kSettingsCalendarIntegration, true);
      sharedPreferencesInstance.setString(
          kSettingsCalendarName, calendarInstance.name);
      sharedPreferencesInstance.setString(
          kSettingsCalendarId, calendarInstance.id);
    });
  }

  NavBar _buildNavBar(BuildContext context) {
    return NavBar(
      "Einstellungen",
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
  final SettingsViewModel settingsViewModel;
  final Function(dynamic key, dynamic value) updateValueForKey;

  _ViewModel({
    this.settingsViewModel,
    this.updateValueForKey,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(
      settingsViewModel: store.state.settingsViewModel,
      updateValueForKey: (key, value) =>
          store.dispatch(UpdateSettingForKeyAction(key, value)),
    );
  }
}
