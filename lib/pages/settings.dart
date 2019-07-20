import 'package:appoint/actions/favorites_action.dart';
import 'package:appoint/actions/settings_action.dart';
import 'package:appoint/models/app_state.dart';
import 'package:appoint/utils/calendar.dart';
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
            store.state.userViewModel.user.companyFavorites));
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
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
                PlatformSpecificSwitch(
                  onChanged: (value) =>
                      calendarIntegrationChanged(value, context, vm),
                  value: vm.settingsViewModel.settings['calendarIntegration'] ??
                      false,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  void calendarIntegrationChanged(
      bool value, BuildContext context, _ViewModel vm) async {
    vm.updateValueForKey('calendarIntegration', value);
    final sharedPreferencesInstance = await SharedPreferences.getInstance();
    sharedPreferencesInstance.setBool('calendarIntegration', value);

    if (!value) {
      vm.updateValueForKey('calendarId', null);
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
        vm.updateValueForKey('calendarId', writeAccessCalendars[0].id);

        showModalBottomSheet(
          context: context,
          builder: (context) => Container(
            height: 350.0,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Wähle einen Kalender aus, in den erstellte Termine eingetragen werden sollen. Dieser Kalender wird auch dafür verwendet, um Terminkonflikte bei der Teminerstellung anzuzeigen.",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Expanded(
                  child: CupertinoPicker(
                    itemExtent: 32.0,
                    onSelectedItemChanged: (int index) {
                      vm.updateValueForKey(
                          'calendarId', writeAccessCalendars[index].id);
                      print(index);
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
          (_) => sharedPreferencesInstance.setString(
              'calendarId', vm.settingsViewModel.settings['calendarId']),
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
