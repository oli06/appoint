import 'package:appoint/actions/user_action.dart';
import 'package:appoint/models/app_state.dart';
import 'package:appoint/pages/favorites.dart';
import 'package:appoint/view_models/user_vm.dart';
import 'package:appoint/widgets/dialog.dart' as appoint;
import 'package:code_input/code_input.dart' as pubdev;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:appoint/widgets/navBar.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildNavBar(context),
      body: StoreConnector<AppState, _ViewModel>(
        converter: (store) => _ViewModel.fromState(store),
        builder: (context, vm) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                _buildUserInformationCard(vm),
                SizedBox(
                  height: 20,
                ),
                _buildVerifyWidget(context, vm),
                SizedBox(
                  height: 20,
                ),
                _buildListView(context),
                Container(
                  child: Expanded(
                    child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: ListTile(
                          title: Text("Ausloggen"),
                          trailing: Icon(CupertinoIcons.getIconData(0xf385)),
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
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Text(
              vm.userViewModel.user.toString(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            Text(
              vm.userViewModel.user.email,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
            ),
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
          GestureDetector(
            onTap: vm.userViewModel.user.verified
                ? null
                : () {
                    _showVerifyScreen(context, vm);
                  },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5.0),
                gradient: LinearGradient(colors: [
                  Color(0xff6dd7c7).withOpacity(0.7),
                  Color(0xff188e9b).withOpacity(0.7)
                ], begin: Alignment.topLeft, end: Alignment.bottomRight),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      vm.userViewModel.user.verified
                          ? "Erfolgreich verifiziert"
                          : "Jetzt verifizieren",
                      style: TextStyle(fontSize: 16),
                    ),
                    Icon(
                      CupertinoIcons.getIconData(0xf3d0),
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 4, left: 4, right: 4),
            child: Text(
              "Durch die Verifizierung erhalten Sie die Möglichkeit, Termine mit noch mehr Unternehmen zu vereinbaren. Gleichzeitig bietet die Verifizeriung eine höhere Vertrauenswürdigkeit gegenüber den Unternehmen.",
              style: TextStyle(color: Colors.grey, fontSize: 14),
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
        information: "Möchten Sie sich wirklich abmelden?",
        informationTextSize: 17,
        userActionWidget: Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                CupertinoButton(
                  child: Text("Abbrechen"),
                  onPressed: () => Navigator.pop(context),
                ),
                CupertinoButton(
                  child: Text("Ja, ausloggen"),
                  onPressed: () {
                    //TODO: logout
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
            "Geben Sie den Code ein, den der Mitarbeiter eines teilnehmenden Unternehmens Ihnen zur Verfügung stellt.",
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
            title: Text("Favoriten"),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () => Navigator.pushNamed(context, FavoritesPage.routeName),
          ),
          Divider(height: 1),
          ListTile(
            title: Text("Einstellungen"),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: () {
              //TODO:
            },
          ),
          Divider(height: 1),
          ListTile(
            title: Text("Tutorial"),
            trailing: Icon(Icons.arrow_forward_ios),
            onTap: null,
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
      height: 57,
      leadingWidget: IconButton(
          icon: Icon(Icons.close), onPressed: () => Navigator.pop(context)),
      trailing: Container(height: 0),
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
        VerifyUserAction(store.state.userViewModel.user.id, code),
      ),
    );
  }
}
