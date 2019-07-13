import 'package:appoint/actions/user_action.dart';
import 'package:appoint/models/app_state.dart';
import 'package:appoint/view_models/user_vm.dart';
import 'package:appoint/widgets/code_input.dart';
import 'package:appoint/widgets/dialog.dart' as appoint;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:appoint/widgets/navBar.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
//import 'package:flutter_code_input/flutter_code_input.dart';

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
                child: ListView(
                  children: <Widget>[
                    _buildUserInformationCard(vm),
                    SizedBox(
                      height: 20,
                    ),
                    _buildVerifyWidget(context, vm),
                    SizedBox(
                      height: 20,
                    ),
                    _buildListView(),
                  ],
                ),
              ),
            ),
      ),
    );
  }

  Container _buildUserInformationCard(_ViewModel vm) {
    return Container(
      height: 100,
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                : () => _showVerifyScreen(context, vm),
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
              "Durch die Verifizierung ihrer Person erhalten Sie die Möglichkeit, Termine mit noch mehr Unternehmen zu vereinbaren. Gleichzeitig bietet die Verifizeriung den Unternehmen eine zusätliche Terminsicherheit bei der Planung.",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ),
        ],
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
                child: CodeInput(
                    length: 6,
                    done: (String code) {
                      vm.verifyUser(code);
                      Navigator.pop(context);
                    }),
                    
              ),
            ),
          ),
    );
  }

  Widget _buildListView() {
    return 
       Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text("Favoriten"),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                //TODO:
              },
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
              onTap: () {
                //TODO:
              },
            ),
            Divider(height: 1),
            ListTile(
              title: Text("Über uns"),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                //TODO:
              },
            ),
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
