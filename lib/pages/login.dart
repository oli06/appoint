import 'dart:convert';

import 'package:appoint/actions/companies_action.dart';
import 'package:appoint/actions/user_action.dart';
import 'package:appoint/data/api.dart';
import 'package:appoint/models/app_state.dart';
import 'package:appoint/models/user.dart';
import 'package:appoint/pages/signup.dart';
import 'package:appoint/utils/constants.dart';
import 'package:appoint/view_models/user_vm.dart';
import 'package:appoint/widgets/form/form_button.dart';
import 'package:appoint/widgets/form/text_button.dart';
import 'package:appoint/widgets/form/appoint_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:http/http.dart';
import 'package:redux/redux.dart' as redux;
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  static final namedRoute = "login";

  Login({Key key}) : super(key: key);

  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  String username;
  String password;
  String info = "";

  final FocusNode _passwordFocus = FocusNode();

  @override
  void dispose() {
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [Color(0xff6dd7c7), Color(0xff188e9b)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: <Widget>[
            _buildWelcomeHeader(),
            StoreConnector<AppState, _ViewModel>(
              converter: (store) => _ViewModel.fromState(store),
              builder: (context, vm) => _buildLoginForm(context, vm),
            ),
          ],
        ),
      ),
    );
  }

  Flexible _buildLoginForm(BuildContext context, _ViewModel vm) {
    return Flexible(
      flex: 27,
      child: Center(
        child: Column(
          children: <Widget>[
            Container(
              width: 350,
              child: Column(
                children: <Widget>[
                  Stack(
                    alignment: AlignmentDirectional.center,
                    children: <Widget>[
                      Card(
                        color: vm.userViewModel.loginProcessIsActive
                            ? Colors.grey[300]
                            : null,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                _buildUsernameInput(context),
                                _buildPasswordInput(context, vm),
                                if (info.isNotEmpty)
                                  Text(
                                    info,
                                    style: TextStyle(color: Colors.red),
                                  ),
                                _buildLoginButton(context, vm),
                              ],
                            ),
                          ),
                        ),
                      ),
                      if (vm.userViewModel.loginProcessIsActive)
                        CupertinoActivityIndicator(),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        _buildCreateAccount(context),
                        _buildForgotPassword(context),
                      ],
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

  AppointFormInput _buildPasswordInput(BuildContext context, _ViewModel vm) {
    return AppointFormInput(
      hintText: "Passwort",
      errorText: "Passwort fehlt",
      focusNode: _passwordFocus,
      action: TextInputAction.go,
      leadingWidget: Icon(CupertinoIcons.getIconData(0xf4c8)),
      obscureText: true,
      onSaved: (value) => setState(() {
        password = value;
      }),
      onFieldSubmitted: (String value) {
        this.password = value;

        _validateAndLogin(vm, context);
      },
    );
  }

  void _validateAndLogin(_ViewModel vm, BuildContext context) {
    if (_formKey.currentState.validate()) {
      print("validate and setLoginProcess active");
      vm.updateLoginProcessIsActive(true);
      _formKey.currentState.save();
      final api = Api();
      api.login(username, password).then((Response response) {
        if (response.statusCode == 200) {
          final jsonMap = json.decode(response.body);
          final token = jsonMap['access_token'];
          api.getUser(jsonMap['userId'], token).then((user) async {
            if (user != null) {
              vm.loadedUserConfigurationAction(user, token);
              final sharedPreferences = await SharedPreferences.getInstance();
              sharedPreferences.setString(kUserNameKey, user.email);
              print("navigate now to app");
              Navigator.pushReplacementNamed(context, "app");
            } else {
              print("failed receiving user");
            }
          });
        } else {
          print("falsches password");
          setState(() {
            info = "E-Mail und Passwort stimmen nicht überein";
          });
        }
        vm.updateLoginProcessIsActive(false);
      });
    }
  }

  Widget _buildUsernameInput(BuildContext context) {
    return StoreConnector<AppState, String>(
      converter: (store) => store.state.userViewModel.username,
      builder: (context, value) => AppointFormInput(
        focusNode: null,
        initialValue: value != null ? value : "",
        keyboardType: TextInputType.emailAddress,
        onSaved: (value) => username = value,
        onFieldSubmitted: (String value) {
          print("username field submitted");
          this.username = value;
          FocusScope.of(context).requestFocus(_passwordFocus);
        },
        hintText: "Benutzername",
        errorText: "Benutzername fehlt",
      ),
    );
  }

  Row _buildLoginButton(BuildContext context, _ViewModel vm) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 0),
            child: FormButton(
              text: "Einloggen",
              onPressed: vm.userViewModel.loginProcessIsActive
                  ? null
                  : () => _validateAndLogin(vm, context),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCreateAccount(BuildContext context) {
    return new TextButton(
      onTap: () => Navigator.pushReplacementNamed(context, SignUp.routeName),
      text: "Account erstellen",
    );
  }

  Widget _buildForgotPassword(BuildContext context) {
    return TextButton(
      onTap: () {
        print("forgot pw");
        //TODO: forgot pw
      },
      text: "Passwort vergessen?",
    );
  }

  Flexible _buildWelcomeHeader() {
    return Flexible(
      flex: 8,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Willkommen bei Appoint",
            style: TextStyle(
                color: Color(0xff333f52),
                fontWeight: FontWeight.bold,
                fontSize: 22),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
            child: Text(
              "–– Jederzeit und überall ––",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Color(0xff333f52),
                  fontWeight: FontWeight.w300,
                  fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class _ViewModel {
  final UserViewModel userViewModel;
  final Function(bool loginProcessIsActive) updateLoginProcessIsActive;
  final Function(String username) forgotPassword;
  final Function(User user, String token) loadedUserConfigurationAction;
  final Function() loadCategories;

  _ViewModel({
    this.userViewModel,
    this.updateLoginProcessIsActive,
    this.loadedUserConfigurationAction,
    this.loadCategories,
    this.forgotPassword,
  });

  static _ViewModel fromState(redux.Store<AppState> store) {
    return _ViewModel(
      userViewModel: store.state.userViewModel,
      updateLoginProcessIsActive: (b) =>
          store.dispatch(UpdateLoginProcessIsActiveAction(b)),
      loadedUserConfigurationAction: (user, token) =>
          store.dispatch(LoadedUserConfigurationAction(user, token)),
      loadCategories: () => store.dispatch(LoadCategoriesAction()),
    );
  }
}
