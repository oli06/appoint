import 'dart:convert';

import 'package:appoint/data/api.dart';
import 'package:appoint/models/useraccount.dart';
import 'package:appoint/pages/login.dart';
import 'package:appoint/pages/signup_success.dart';
import 'package:appoint/utils/parse.dart';
import 'package:appoint/widgets/form/appoint_input.dart';
import 'package:appoint/widgets/form/form_button.dart';
import 'package:appoint/widgets/form/text_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';

class SignUp extends StatefulWidget {
  static final routeName = "signup";
  const SignUp({Key key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  String info = "";

  String _firstName;
  String _lastName;
  String _phone;
  String _email;
  String _password;
  bool _hasAgreed;
  DateTime _birthday;

  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _repeatPasswordFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _mailAdressFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();
  final _agbRecognizer = TapGestureRecognizer();
  final _usageRecognizer = TapGestureRecognizer();

  @override
  void initState() {
    super.initState();

    _hasAgreed = false;

    _agbRecognizer.onTap = () {
      print("agbs clicked");
    };

    _usageRecognizer.onTap = () {
      print("on usage tab");
    };
  }

  @override
  void dispose() {
    _passwordFocus.dispose();
    _lastNameFocus.dispose();
    _mailAdressFocus.dispose();
    _phoneFocus.dispose();
    _repeatPasswordFocus.dispose();
    _usageRecognizer.dispose();
    _agbRecognizer.dispose();
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
            if (info.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  info,
                  style: TextStyle(color: Colors.red),
                ),
              ),
            Flexible(
              flex: 27,
              child: Center(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: CupertinoScrollbar(
                        child: ListView(
                          children: <Widget>[
                            _buildNameInput(),
                            _buildMailInput(),
                            _buildBirthdayInput(),
                            _buildPhoneInput(),
                            _buildPasswordInput(),
                            _buildRepeatPasswordInput(),
                            _buildAgreements(context),
                            _buildRegisterButton(context),
                            _buildBackToLoginButton(context),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextButton _buildBackToLoginButton(BuildContext context) {
    return TextButton(
      onTap: () => Navigator.pushReplacementNamed(context, Login.namedRoute),
      text: "oder zum Login",
    );
  }

  Row _buildRegisterButton(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 0),
            child: FormButton(
              text: "Registrierung abschließen",
              onPressed: () {
                _formKey.currentState.save();
                if (_formKey.currentState.validate() &&
                    _hasAgreed &&
                    _birthday != null) {
                  Api()
                      .register(UserAccount(
                    password: _password,
                    birthday: _birthday,
                    email: _email,
                    firstName: _firstName,
                    lastName: _lastName,
                    phone: _phone,
                  ))
                      .then((result) {
                    if (result.statusCode == 200) {
                      print("created user with success");
                      Navigator.pushReplacementNamed(
                          context, SignupSuccess.namedRoute);
                    } else {
                      print("failed user registration");
                      setState(() {
                        info = json.decode(result.body);
                      });
                    }
                  });
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  Row _buildAgreements(BuildContext context) {
    return Row(
      children: <Widget>[
        Checkbox(
          onChanged: (newValue) {
            setState(() {
              _hasAgreed = newValue;
            });
          },
          value: _hasAgreed,
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
                style: TextStyle(fontSize: 15, color: Colors.black),
                children: <TextSpan>[
                  TextSpan(text: "Ich stimem den "),
                  TextSpan(
                      text: "allgemeinen Geschäftsbedingungen",
                      recognizer: _agbRecognizer,
                      style: TextStyle(color: Theme.of(context).primaryColor)),
                  TextSpan(text: " und "),
                  TextSpan(
                      text: "Nutzungsbedingungen",
                      recognizer: _usageRecognizer,
                      style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold)),
                  TextSpan(text: " "),
                ]),
          ),
        ),
      ],
    );
  }

  AppointFormInput _buildRepeatPasswordInput() {
    return AppointFormInput(
      focusNode: _repeatPasswordFocus,
      validator: (value) {
        print(_password);
        if (value != _password) {
          return "Passwörter stimmen nicht überein";
        } else
          return null;
      },
      hintText: "Passwort wiederholen",
      //TODO: fix: currently workaround, um kein icon zu zeigen,
      //aber trotzdem
      //auf der selben reihe mit den anderen Textfeldern zu sein
      leadingWidget: Container(width: 34),
      errorText: "Passwort fehlt",
      onFieldSubmitted: (value) {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      showSuffixIcon: true,
      obscureText: true,
    );
  }

  AppointFormInput _buildPasswordInput() {
    return AppointFormInput(
      focusNode: _passwordFocus,
      hintText: "Passwort",
      validator: (value) {
        if (value.isEmpty) {
          return "Passwort fehlt";
          //TODO: regexp check; correct password recipe --> sonderzeichen, zahl etc
        }
        return null;
      },
      leadingWidget: Card(
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Icon(
            CupertinoIcons.getIconData(0xf4c8),
          ),
        ),
      ),
      errorText: "Passwort fehlt",
      onSaved: (value) => _password = value,
      onFieldSubmitted: (value) {
        FocusScope.of(context).requestFocus(_repeatPasswordFocus);
        _password = value;
      },
      showSuffixIcon: true,
      obscureText: true,
    );
  }

  Widget _buildBirthdayInput() {
    return AppointFormInput(
      focusNode: null,
      errorText: "",
      hintText: "",
      leadingWidget: Card(
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Icon(
            CupertinoIcons.getIconData(0xf2d1),
          ),
        ),
      ),
      onFieldSubmitted: (value) {},
      showSuffixIcon: true,
      customInputWidget: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: FlatButton(
              padding: EdgeInsets.zero,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  _birthday != null
                      ? Parse.dateOnly.format(_birthday)
                      : "Geburtsdatum",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                      color: _birthday == null ? Colors.black54 : null),
                ),
              ),
              onPressed: () => _birthdayInputClicked(),
            ),
          ),
        ],
      ),
    );
  }

  void _birthdayInputClicked() {
    DateTime now = DateTime.now();
    DateTime maxDate = DateTime(now.year - 18, now.month, now.day);

    if (Theme.of(context).platform == TargetPlatform.iOS) {
      DatePicker.showDatePicker(
        context,
        dateFormat: "dd-MMMM-yyyy",
        onConfirm: (value, _) {
          setState(() {
            _birthday = value;
          });
          FocusScope.of(context).requestFocus(_phoneFocus);
        },
        maxDateTime: maxDate,
        initialDateTime: _birthday != null ? _birthday : maxDate,
        pickerTheme: DateTimePickerTheme(
            cancel: Text(
              "Abbrechen",
            ),
            confirm: Text(
              "Auswählen",
              style: TextStyle(color: Color(0xff1991eb)),
            )),
      );
    } else {
      showDatePicker(
        context: context,
        lastDate: maxDate,
        initialDate: _birthday != null ? _birthday : maxDate,
        firstDate: DateTime(1900),
      ).then((value) {
        setState(() {
          _birthday = value;
        });
        FocusScope.of(context).requestFocus(_phoneFocus);
      });
    }
  }

  AppointFormInput _buildPhoneInput() {
    return AppointFormInput(
      hintText: "Telefonnummer",
      focusNode: _phoneFocus,
      keyboardType: TextInputType.phone,
      leadingWidget: Card(
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Icon(CupertinoIcons.phone),
        ),
      ),
      errorText: "Telefonnummer fehlt",
      onSaved: (value) => _phone = value,
      onFieldSubmitted: (value) {
        FocusScope.of(context).requestFocus(_passwordFocus);
        //_phone = value;
      },
      showSuffixIcon: true,
    );
  }

  AppointFormInput _buildMailInput() {
    return AppointFormInput(
      hintText: "e-Mail Adresse",
      focusNode: _mailAdressFocus,
      keyboardType: TextInputType.emailAddress,
      onSaved: (value) => _email = value,
      leadingWidget: Card(
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: Icon(CupertinoIcons.mail),
        ),
      ),
      errorText: "e-Mail Adresse fehlt",
      onFieldSubmitted: (value) {
        _email = value;
        print("saving email, new value: $_email");
        _birthdayInputClicked();
      },
      showSuffixIcon: true,
    );
  }

  Row _buildNameInput() {
    return Row(
      children: <Widget>[
        Flexible(
          child: AppointFormInput(
            focusNode: null,
            hintText: "Vorname",
            errorText: "Vorname fehlt",
            onSaved: (value) => _firstName = value,
            onFieldSubmitted: (value) {
              FocusScope.of(context).requestFocus(_lastNameFocus);
              //_firstName = value;
            },
            showSuffixIcon: false,
            leadingWidget: Card(
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: Icon(CupertinoIcons.person),
              ),
            ),
          ),
        ),
        Flexible(
          child: AppointFormInput(
            showLeadingWidget: false,
            focusNode: _lastNameFocus,
            hintText: "Nachname",
            errorText: "Nachname fehlt",
            showSuffixIcon: false,
            onSaved: (value) => _lastName = value,
            onFieldSubmitted: (value) {
              FocusScope.of(context).requestFocus(_mailAdressFocus);
              //_lastName = value;
            },
          ),
        ),
      ],
    );
  }

  Flexible _buildWelcomeHeader() {
    return Flexible(
      flex: 8,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Row(
            children: <Widget>[],
          ),
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
              "Registriere dich, um direkt loszulegen",
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
