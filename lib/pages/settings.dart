import 'package:appoint/actions/favorites_action.dart';
import 'package:appoint/actions/settings_action.dart';
import 'package:appoint/models/app_state.dart';
import 'package:appoint/utils/calendar.dart';
import 'package:appoint/utils/constants.dart';
import 'package:appoint/view_models/settings_vm.dart';
import 'package:appoint/widgets/navBar.dart';
import 'package:appoint/widgets/switch.dart';
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
      converter: (store) => _ViewModel.fromStore(store),
      onInit: (store) {
        store.dispatch(LoadFavoritesAction(
            store.state.userViewModel.user.id));
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
              "Wenn Sie die Kalenderintegration aktivieren, werden auf Grundlage des Systemkalenders Terminkonflikte bei der Terminerstellung angezeigt",
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
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              PlatformSpecificSwitch(
                onChanged: vm.settingsViewModel
                            .settings[kSettingsCalendarIntegration] !=
                        true
                    ? null
                    : (value) =>
                        vm.updateValueForKey(kSettingsSaveToCalendar, value),
                value: vm.settingsViewModel.settings[kSettingsSaveToCalendar] ??
                    false,
              )
            ],
          ),
        ),
      ),
      (vm.settingsViewModel.settings[kSettingsSaveToCalendar] ?? false) == true
          ? Text(
              "Neu erstellte Termine werden automatisch in den Kalender \"${vm.settingsViewModel.settings[kSettingsCalendarName]}\" übernommen.",
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            )
          : Text(
              "Aktivieren Sie diese Funktion, damit neu erstellte Termine automatisch in den System Kalender übernommen werdenb.",
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
    ];
  }

  void calendarIntegrationChanged(
      bool value, BuildContext context, _ViewModel vm) async {
    vm.updateValueForKey(kSettingsCalendarIntegration, value);

    final sharedPreferencesInstance = await SharedPreferences.getInstance();
    sharedPreferencesInstance.setBool(kSettingsCalendarIntegration, value);

    if (!value) {
      vm.updateValueForKey(kSettingsCalendarId, null);
      return;
    }

    final cal = Calendar();
    cal.retrieveCalendars().then(
      (calendars) {
        if (calendars == null) {
          return;
        }

        final writeAccessCalendars =
            calendars.where((c) => !c.isReadOnly).toList();

        //If the user doesnt select another item, there would be no notice,
        //that the initial value (index 0) is selected --> no entry in redux
        vm.updateValueForKey(kSettingsCalendarId, writeAccessCalendars[0].id);
        vm.updateValueForKey(kSettingsCalendarName, writeAccessCalendars[0].name);

        showModalBottomSheet(
          context: context,
          builder: (context) => Container(
            height: 200.0,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: CupertinoPicker(
                    itemExtent: 32.0,
                    onSelectedItemChanged: (int index) {
                      vm.updateValueForKey(
                          kSettingsCalendarId, writeAccessCalendars[index].id);
                      vm.updateValueForKey(kSettingsCalendarName,
                          writeAccessCalendars[index].name);
                    },
                    children: new List<Widget>.generate(
                      writeAccessCalendars.length,
                      (int index) {
                        return new Center(
                          child: new Text(writeAccessCalendars[index].name),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ).then(
          (_) {
            sharedPreferencesInstance.setString(kSettingsCalendarId,
                vm.settingsViewModel.settings[kSettingsCalendarId]);
            sharedPreferencesInstance.setString(kSettingsCalendarName,
                vm.settingsViewModel.settings[kSettingsCalendarName]);
          },
        );
      },
    );
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
      trailing: Container(
        height: 0,
      ),
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
