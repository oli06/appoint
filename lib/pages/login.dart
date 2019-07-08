import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  Login({Key key}) : super(key: key);

  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _passwordFocus = FocusNode();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
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
            Padding(
              padding: const EdgeInsets.only(bottom: 100.0, top: 100),
              child: Column(
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
            ),
            Center(
              child: Column(
                children: <Widget>[
                  Container(
                    width: 350,
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Row(
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Icon(CupertinoIcons.person),
                                      ),
                                      Flexible(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: TextFormField(
                                            textInputAction:
                                                TextInputAction.next,
                                            onFieldSubmitted: (value) {
                                              FocusScope.of(context)
                                                  .requestFocus(_passwordFocus);
                                            },
                                            validator: (value) {
                                              if (value.isEmpty) {
                                                return "Benutzername fehlt";
                                              }
                                              return null;
                                            },
                                            style: TextStyle(fontSize: 18),
                                            controller: _usernameController,
                                            decoration: InputDecoration(
                                              hintText: "Benutzername",
                                              suffixIcon: IconButton(
                                                  icon: Icon(
                                                      CupertinoIcons.clear),
                                                  onPressed: () =>
                                                      _usernameController.text =
                                                          ""),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(
                                          CupertinoIcons.getIconData(0xf4c8)),
                                    ),
                                    Flexible(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8.0),
                                        child: TextFormField(
                                          obscureText: true,
                                          controller: _passwordController,
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return "Passwort fehlt";
                                            }

                                            return null;
                                          },
                                          style: TextStyle(fontSize: 18),
                                          focusNode: _passwordFocus,
                                          textInputAction: TextInputAction.go,
                                          onFieldSubmitted: (_) {
                                            if (_formKey.currentState
                                                .validate())
                                              Navigator.pushReplacementNamed(
                                                  context, "/app");
                                            //TODO auth
                                          },
                                          decoration: InputDecoration(
                                            hintText: "Passwort",
                                            suffixIcon: IconButton(
                                                icon:
                                                    Icon(CupertinoIcons.clear),
                                                onPressed: () =>
                                                    _passwordController.text =
                                                        ""),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              FlatButton(
                                textColor: Color(0xff333f52),
                                color: Color(0xff1991eb),
                                child: Text(
                                  "Einloggen",
                                  style: TextStyle(fontSize: 17),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState.validate())
                                    Navigator.pushReplacementNamed(context, "/app");
                                  //TODO auth
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
