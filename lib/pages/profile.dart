import 'package:appoint/actions/user_action.dart';
import 'package:appoint/models/app_state.dart';
import 'package:appoint/pages/favorites.dart';
import 'package:appoint/pages/login.dart';
import 'package:appoint/pages/past_appointments.dart';
import 'package:appoint/pages/settings.dart';
import 'package:appoint/utils/constants.dart';
import 'package:appoint/utils/icons.dart';
import 'package:appoint/view_models/user_vm.dart';
import 'package:appoint/widgets/dialog.dart' as appoint;
import 'package:appoint/widgets/expansion_widget.dart';
import 'package:code_input/code_input.dart' as pubdev;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:appoint/widgets/navBar.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildNavBar(context),
      body: StoreConnector<AppState, _ViewModel>(
        distinct: true,
        converter: (store) => _ViewModel.fromState(store),
        builder: (context, vm) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                _buildUserInformationCard(vm),
                SizedBox(
                  height: 10,
                ),
                _buildVerifyWidget(context, vm),
                SizedBox(
                  height: 10,
                ),
                _buildListView(context),
                Container(
                  child: Expanded(
                    child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: ListTile(
                          title: Text("Ausloggen"),
                          //trailing: Icon(CupertinoIcons.getIconData(0xf385)),
                          trailing: Icon(AppointIcons.getIconByCodePoint(0xf385)),
                          onTap: () => _showLogoutScreen(context, vm)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserInformationCard(_ViewModel vm) {
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              vm.userViewModel?.user?.toString() ?? "",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(
              vm.userViewModel?.user?.email ?? "",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
            ),
            if (vm.userViewModel?.user?.address != null)
              Text(
                vm.userViewModel.user.address.toCityString(),
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerifyWidget(BuildContext context, _ViewModel vm) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0, right: 4.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Flexible(
                  child: ExpansionWidget(
                    title: "Konto verifizieren",
                    children: <Widget>[
                      Text(
                        "Durch die Verifizierung erhältst du die Möglichkeit, Termine mit noch mehr Unternehmen zu vereinbaren. Gleichzeitig bietet die Verifizeriung eine höhere Vertrauenswürdigkeit gegenüber den Unternehmen.",
                        style: const TextStyle(fontSize: 14),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: CupertinoButton(
                            //TODO: NYI verify
                            padding: EdgeInsets.zero,
                            child: Text(
                              "Jetzt verifizieren",
                              style: TextStyle(
                                  color:
                                      null /* Theme.of(context).accentColor */),
                            ),
                            onPressed:
                                null /*  () {
                            _showVerifyScreen(context, vm);
                          }, */
                            ),
                      ),
                    ],
                    trailing: Icons.keyboard_arrow_up,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _showLogoutScreen(BuildContext context, _ViewModel vm) {
    showCupertinoDialog(
      context: context,
      builder: (context) => appoint.Dialog(
        title: "Abmelden",
        information: "Möchtest Du dich wirklich abmelden?",
        informationTextSize: 17,
        userActionWidget: Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                CupertinoButton(
                  child: Text(
                    "Abbrechen",
                    style: TextStyle(color: Theme.of(context).accentColor),
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                CupertinoButton(
                  child: Text("Ja, ausloggen"),
                  onPressed: () async {
                    final SharedPreferences sharedPreferences =
                        await SharedPreferences.getInstance();
                    sharedPreferences.remove(kTokenKey).then((val) {
                      sharedPreferences.remove(kTokenKey);
                      Navigator.pushNamedAndRemoveUntil(
                          context, Login.namedRoute, (_) => false);
                    });
                  },
                )
              ],
            )),
      ),
    );
  }

  _showVerifyScreen(BuildContext context, _ViewModel vm) {
    showCupertinoDialog(
      context: context,
      builder: (context) => appoint.Dialog(
        title: "Code eingeben",
        information:
            "Gib den Code ein, den der Mitarbeiter eines teilnehmenden Unternehmens dir zur Verfügung stellt.",
        userActionWidget: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 8),
          child: Center(
            child: pubdev.CodeInput(
              length: 6,
              keyboardType: TextInputType.number,
              builder: pubdev.CodeInputBuilders.rectangle(
                borderRadius: BorderRadius.circular(10),
                color: Colors.transparent,
                border: Border.all(),
                textStyle: TextStyle(
                    fontSize: 24, color: Theme.of(context).accentColor),
              ),
              onFilled: (String value) {
                vm.verifyUser(value);
                //TODO: wait until completion
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text("Einstellungen"),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () => Navigator.pushNamed(context, SettingsPage.routeName),
          ),
          Divider(height: 1),
          ListTile(
            title: Text("Favoriten"),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () => Navigator.pushNamed(context, FavoritesPage.routeName),
          ),
          Divider(height: 1),
          ListTile(
            title: Text("vergangene Termine"),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () =>
                Navigator.pushNamed(context, PastAppointmentPage.routeName),
          ),
          Divider(height: 1),
          ListTile(
              title: Text("Über uns"),
              trailing: Icon(Icons.arrow_forward_ios),
              //TODO: about-us url
              onTap: () => launch("https://www.example.com/about-us")),
          Divider(height: 1),
        ],
      ),
    );
  }

  NavBar _buildNavBar(BuildContext context) {
    return NavBar(
      "Profil",
      height: 40,
      leadingWidget: Container(
        padding: EdgeInsets.only(left: 10.0),
        child: Icon(CupertinoIcons.profile_circled),
      ),
    );
  }
}

class _ViewModel {
  final UserViewModel userViewModel;
  final Function(String code) verifyUser;

  _ViewModel({this.userViewModel, this.verifyUser});

  static _ViewModel fromState(Store<AppState> store) {
    return _ViewModel(
      userViewModel: store.state.userViewModel,
      verifyUser: (String code) => store.dispatch(
        VerifyUserAction(code),
      ),
    );
  }
}
