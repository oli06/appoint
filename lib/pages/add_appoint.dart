import 'package:appoint/model/appoint.dart';
import 'package:appoint/model/company.dart';
import 'package:appoint/model/period.dart';
import 'package:appoint/widgets/company_tile.dart';
import 'package:appoint/widgets/navBar.dart';
import 'package:appoint/pages/select_company.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef OnSaveCallback = Function(
    String title, Company company, Period period, String description);

class AddAppoint extends StatefulWidget {
  final Appoint appoint;
  final bool isEditing;
  final OnSaveCallback onSave;

  AddAppoint(
      {Key key, this.isEditing = false, this.appoint, @required this.onSave})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return AddAppointState();
  }
}

class AddAppointState extends State<AddAppoint>
    with SingleTickerProviderStateMixin {
  final _appointFormKey = GlobalKey<FormState>();

  String _title;
  Company _company;
  Period _period;
  String _description;

  @override
  void initState() {
    if (widget.isEditing) {
      _company = widget.appoint.company;
      _title = widget.appoint.title;
      _period = widget.appoint.period;
      _description = widget.appoint.description;

      _controller.text = _title;
    }

    _controller.addListener(onChange);
    super.initState();
  }

  TextEditingController _controller = TextEditingController();

  void onChange() {
    setState(() {
      _title = _controller.text;
    });
  }

  bool _isValid() {
    return _title != null && _title.isNotEmpty && _company != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            buildNavBar(),
            _getLowerLayer(),
          ],
        ),
      ),
    );
  }

  NavBar buildNavBar() {
    return NavBar(
      "Neuer Termin",
      leadingWidget: IconButton(
        icon: Icon(Icons.close),
        onPressed: () => Navigator.pop(context),
      ),
      endingWidget: CupertinoButton(
        padding: EdgeInsets.zero,
        child: Text(
          widget.isEditing ? "Speichern" : "Erstellen",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        onPressed: _isValid()
            ? () => widget.onSave(_title, _company, _period, _description)
            : null,
      ),
    );
  }

  Widget _firstCard() {
    final Function companyTap = () => showCupertinoModalPopup(
          context: context,
          builder: (context) => SelectCompany(),
        ).then((selectedCompany) {
          if (selectedCompany != null) {
            setState(() {
              _company = selectedCompany;
            });
          }
        });

    return Container(
      child: Card(
        elevation: 2,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Container(
                    height: 50,
                    padding: EdgeInsets.only(
                      left: 15,
                      right: 15,
                    ),
                    child: Align(
                      child: TextFormField(
                        controller: _controller,
                        autofocus: widget.isEditing ? false : true,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration.collapsed(
                          hintText: "Termin",
                        ),
                      ),
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                )
              ],
            ),
            Container(
              padding: EdgeInsets.only(
                left: 15,
                right: 15,
              ),
              child: Divider(
                height: 1,
              ),
            ),
            _company == null
                ? Container(
                    height: 50,
                    child: FlatButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Unternehmen auswählen..."),
                          Icon(
                            CupertinoIcons.getIconData(0xf3d0),
                            color: Colors.black,
                          ),
                        ],
                      ),
                      onPressed: companyTap,
                    ),
                  )
                : CompanyTile(
                    company: _company,
                    onTap: companyTap,
                  ),
          ],
        ),
      ),
    );
  }

  Widget _getLowerLayer() {
    return Form(
      key: _appointFormKey,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        children: <Widget>[
          SizedBox(
            height: 20,
          ),
          _firstCard(),
          SizedBox(
            height: 20,
          ),
          _secondCard(),
        ],
      ),
    );
  }

  Card _secondCard() {
    return Card(
      
      color: _company == null ? Colors.grey[350] : null,
      elevation: 2,
      child: Container(
        height: 100,
        padding: EdgeInsets.only(
          left: 15,
          right: 15,
        ),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                
                height: 35,
                padding: EdgeInsets.only(top: 10),
                child: Text(
                  "Zeitraum wählen",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: OutlineButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Datum"),
                          Icon(Icons.event),
                        ],
                      ),
                      onPressed: _company == null
                          ? null
                          : () {} // => _selectPeriod(true),
                      ),
                ),
                Expanded(
                  child: OutlineButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text("Uhrzeit"),
                          Icon(Icons.watch_later),
                        ],
                      ),
                      onPressed: _company == null
                          ? null
                          : () {} //=> _selectPeriod(false),
                      ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  /*void _selectPeriod(bool isDateMode) {
    bool isIos = Theme.of(context).platform == TargetPlatform.iOS;

    final firstDate = DateTime.now();

    if (isIos) {
      showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoBottomPicker(
              picker: CupertinoDatePicker(
                mode: isDateMode
                    ? CupertinoDatePickerMode.date
                    : CupertinoDatePickerMode.time,
                onDateTimeChanged: (date) {
                  model.setSelectedDate(date);
                },
                initialDateTime: firstDate,
                maximumYear: 2100,
                use24hFormat: true,
              ),
            ),
      ).then((val) {
        showCupertinoModalPopup(
          context: context,
          builder: (context) => SelectTimespan(
                model: model,
              ),
        );
      });
    } else {
      isDateMode == true
          ? showDatePicker(
              context: context,
              firstDate: firstDate,
              lastDate: DateTime(2100),
              initialDate: firstDate.add(
                Duration(days: 1),
              ),
              selectableDayPredicate: (date) {
                if (date.weekday == DateTime.sunday) {
                  return false;
                } else {
                  return true;
                }
              }).then((date) {
              if (date == null) {
                return;
              }

              showCupertinoModalPopup(
                context: context,
                builder: (context) => SelectTimespan(
                      model: model,
                    ),
              );
            })
          : showTimePicker(
                  context: context, initialTime: TimeOfDay(hour: 8, minute: 0))
              .then(
              (time) {
                showCupertinoModalPopup(
                  context: context,
                  builder: (context) => SelectTimespan(
                        model: model,
                      ),
                );
              },
            );
    }
  }*/
}
