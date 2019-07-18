import 'package:appoint/pages/signup.dart';
import 'package:appoint/widgets/form/form_button.dart';
import 'package:appoint/widgets/form/text_button.dart';
import 'package:appoint/widgets/form/appoint_input.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  static final namedRoute = "login";
  
  Login({Key key}) : super(key: key);

  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  //final TextEditingController _usernameController = TextEditingController();
  //final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocus = FocusNode();

  @override
  void dispose() {
/*     _usernameController.dispose();
    _passwordController.dispose(); */
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
            _buildLoginForm(context),
          ],
        ),
      ),
    );
  }

  Flexible _buildLoginForm(BuildContext context) {
    return Flexible(
      flex: 27,
      child: Center(
        child: Column(
          children: <Widget>[
            Container(
              width: 350,
              child: Column(
                children: <Widget>[
                  Card(
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
                            _buildPasswordInput(context),
                            _buildLoginButton(context),
                          ],
                        ),
                      ),
                    ),
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

  AppointFormInput _buildPasswordInput(BuildContext context) {
    return AppointFormInput(
      //controller: _passwordController,
      hintText: "Passwort",
      errorText: "Passwort fehlt",
      focusNode: _passwordFocus,
      action: TextInputAction.go,
      leadingWidget: Icon(CupertinoIcons.getIconData(0xf4c8)),
      obscureText: true,
      onFieldSubmitted: (_) {
        if (_formKey.currentState.validate())
          Navigator.pushReplacementNamed(context, "app");
        //TODO auth
      },
    );
  }

  AppointFormInput _buildUsernameInput(BuildContext context) {
    return AppointFormInput(
      focusNode: null,
      onFieldSubmitted: (String value) =>
          FocusScope.of(context).requestFocus(_passwordFocus),
      hintText: "Benutzername",
      errorText: "Benutzername fehlt",
      //controller: _usernameController,
    );
  }

  Row _buildLoginButton(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 0),
            child: FormButton(
              text: "Einloggen",
              onPressed: () {
                if (_formKey.currentState.validate())
                  Navigator.pushReplacementNamed(context, "app");
                //TODO auth
              },
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
              "Melden Sie sich an oder registrieren Sie sich, um Termine erstellen zu können",
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
