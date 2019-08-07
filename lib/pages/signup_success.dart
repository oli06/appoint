import 'package:appoint/pages/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignupSuccess extends StatelessWidget {
  static final namedRoute = "signup_success";

  SignupSuccess({Key key}) : super(key: key);

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
            _buildBody(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Flexible(
      flex: 27,
      child: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                  "Du hast dich erfolgreich registriert!\nWir haben dir eine Bestätigungsmail gesendet. Klicke auf den Link in der E-Mail. Anschließend kannst du dich mit deinen Zugangsdaten in der App anmelden", style: TextStyle(fontSize: 16),),
            ),
            FlatButton(
              child: Text("Zurück zum Login",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 20)),
              onPressed: () => Navigator.pushNamedAndRemoveUntil(
                  context, Login.namedRoute, (_) => false),
            ),
          ],
        ),
      ),
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
