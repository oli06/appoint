import 'package:appoint/view_models/add_appoint_vm.dart';
import 'package:appoint/models/app_state.dart';
import 'package:appoint/models/appoint.dart';
import 'package:appoint/models/company.dart';
import 'package:appoint/models/period.dart';
import 'package:appoint/pages/select_period.dart';
import 'package:appoint/utils/parse.dart';
import 'package:appoint/widgets/company_tile.dart';
import 'package:appoint/widgets/navBar.dart';
import 'package:appoint/pages/select_company.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

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
  Company _company = Company(
      address: null,
      id: 1,
      category: Category.DOCTOR,
      name: "DreamCompany",
      picture: "http://placehold.it/32x32",
      description: "Beschreibung",
      isPartner: true,
      rating: 3.5);
  Period _period;
  String _description;

  @override
  void initState() {
    if (widget.isEditing) {
      _company = widget.appoint.company;
      _title = widget.appoint.title;
      _period = widget.appoint.period;
      _description = widget.appoint.description;

      _titleController.text = _title;
    }

    _titleController.addListener(onTitleChange);
    _descriptionController.addListener(onDescriptionChange);
    super.initState();
  }

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  void onTitleChange() {
    setState(() {
      _title = _titleController.text;
    });
  }

  void onDescriptionChange() {
    setState(() {
      _description = _descriptionController.text;
    });
  }


  bool _isValid() {
    return _title != null &&
        _title.isNotEmpty &&
        _company != null &&
        _period != null;
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
        onInit: (store) {
          if (widget.isEditing) {}
        },
        converter: _ViewModel.fromStore,
        builder: (context, vm) {
          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    buildNavBar(),
                    _getLowerLayer(),
                  ],
                ),
              ),
            ),
          );
        });
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
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: _isValid() ? Color(0xff09c199) : null),
        ),
        onPressed: _isValid()
            ? () { widget.onSave(_title, _company, _period, _description); Navigator.pop(context);}
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
              _period = null;
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
                        controller: _titleController,
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
            height: 10,
          ),
          _firstCard(),
          SizedBox(
            height: 20,
          ),
          _secondCard(),
          SizedBox(
            height: 20,
          ),
          _thirdCard(),
        ],
      ),
    );
  }

  Card _secondCard() {
    return Card(
      color: _company == null ? Colors.grey[350] : null,
      elevation: 2,
      child: Container(
        height: 130,
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
            _period == null
                ? Container(
                    height: 50,
                    child: FlatButton(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Zeitraum auswählen..."),
                          Icon(
                            CupertinoIcons.getIconData(0xf3d0),
                            color: Colors.black,
                          ),
                        ],
                      ),
                      onPressed: _company == null ? null : _selectPeriodPressed,
                    ),
                  )
                : GestureDetector(
                    onTap: _selectPeriodPressed,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                      child: Container(
                        color: Colors
                            .transparent, //hack: make widget also clickable where no other (text) widget is placed
                        child: Column(
                          children: <Widget>[
                            Align(
                              child: Text(
                                Parse.dateWithWeekday.format(_period.start),
                                style: TextStyle(fontSize: 17),
                              ),
                              alignment: Alignment.centerLeft,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    height: (_period.duration.inMinutes / 1.5),
                                    width: 5,
                                    color: Colors.green,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      "${Parse.hoursWithMinutes.format(_period.start.toUtc())} - ${Parse.hoursWithMinutes.format(_period.getPeriodEnd().toUtc())}",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  Card _thirdCard() {
    return Card(
      
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: TextFormField(
            controller: _descriptionController,
            minLines: 6,
            maxLines: 10,
            maxLength: 256,
            decoration: InputDecoration.collapsed(
              hintText: "Information / Hintergründe zum Termin:",
            ),
          ),
        ),
      ),
    );
  }

  void _selectPeriodPressed() => showCupertinoModalPopup(
        context: context,
        builder: (context) => SelectPeriod(
              companyId: _company.id,
            ),
      ).then((selectedPeriod) {
        if (selectedPeriod != null) {
          setState(() {
            _period = selectedPeriod;
          });
        }
      });
}

class _ViewModel {
  final AddAppointViewModel addAppointViewModel;

  _ViewModel({@required this.addAppointViewModel});

  static _ViewModel fromStore(Store<AppState> store) {
    return _ViewModel(addAppointViewModel: store.state.addAppointViewModel);
  }
}
