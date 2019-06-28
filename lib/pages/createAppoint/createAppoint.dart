import 'package:appoint/base/navBar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rubber/rubber.dart';

class CreateAppoint extends StatefulWidget {
  CreateAppoint({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return CreateAppointState();
  }
}

class CreateAppointState extends State<CreateAppoint>
    with SingleTickerProviderStateMixin {
  final _appointFormKey = GlobalKey<FormState>();
  final _bottomSheetKey = GlobalKey<ScaffoldState>();
  RubberAnimationController _controller;
  ScrollController _scrollController = ScrollController();

  Select _activeSelection = Select.Company;

  @override
  void initState() {
    _controller = RubberAnimationController(
        vsync: this,
        upperBoundValue: AnimationControllerValue(percentage: 0.9),
        lowerBoundValue: AnimationControllerValue(percentage: 0.0),
        halfBoundValue: AnimationControllerValue(percentage: 0.5),
        duration: Duration(milliseconds: 200));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _bottomSheetKey,
      body: SafeArea(
          child: Column(
        children: <Widget>[
          NavBar(
            "Neuer Termin",
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () => Navigator.pop(context),
            ),
          ),
/*           Container(
            child: RubberBottomSheet(
              animationController: _controller,
              scrollController: _scrollController,
              headerHeight: 160,
              header: _selectHeader(context),
              lowerLayer: _getLowerLayer(),
              upperLayer: _getUpperLayer(),
            ),
          ), */
        ],
      )),
    );
  }

  static final Map<int, Widget> selectable = <int, Widget>{
    0: Row(
      children: <Widget>[
        Expanded(
          child: Container(
              padding: EdgeInsets.only(left: 5.0, right: 5.0),
              child: Text("Favoriten")),
        ),
        Icon(Icons.favorite)
      ],
    ),
    1: Row(
      children: <Widget>[
        Expanded(
          child: Container(
              padding: EdgeInsets.only(left: 5.0, right: 5.0),
              child: Text("Alle")),
        ),
        Icon(Icons.list)
      ],
    ),
  };

  int currentlySelected = 0;
  String dropdownValue = "Arzt";

  Widget _category() {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return CupertinoPicker(
        children: <Widget>[],
      );
    } else {
      return null;
    }
  }

  Widget _selectHeader(context) {
    return Container(
      color: Colors.transparent,
      child: Container(
          padding: EdgeInsets.only(left: 5.0, right: 5.0),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.black54,
                    offset: Offset(0, 4),
                    blurRadius: 10.0)
              ],
              color: Colors.white,
              borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(15.0),
                  topRight: const Radius.circular(15.0))),
          child: Column(
            children: <Widget>[
              Center(
                heightFactor: 5,
                child: Container(
                  width: 30,
                  height: 4,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "Unternehmen auswählen",
                  textAlign: TextAlign.left,
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 22),
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Text(
                  "anschließend können Sie einen Termin wählen",
                  style: TextStyle(fontSize: 12),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.topRight,
                child: DropdownButton<String>(
                  value: dropdownValue,
                  onChanged: (String newValue) {
                    setState(() {
                      dropdownValue = newValue;
                    });
                  },
                  items: <String>['Arzt', 'Steuerberater', 'Friseur', 'Andere']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              CupertinoSegmentedControl(
                children: selectable,
                groupValue: currentlySelected,
                onValueChanged: (selected) {
                  setState(() {
                    currentlySelected = selected;
                  });
                },
              ),
            ],
          )),
    );
  }

  Widget _getLowerLayer() {
    return SafeArea(
        child: Form(
            key: _appointFormKey,
            child: ListView(children: <Widget>[
              SizedBox(
                height: 30,
              ),
              Divider(
                color: Colors.blue,
                height: 0.0,
              ),
              Container(
                color: Colors.deepOrange,
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                height: 40,
                alignment: Alignment.centerLeft,
                child: TextField(
                  onTap: () {
                    print("taoppppepejhfwfjw");
                    _controller.setVisibility(false);
                  },
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration.collapsed(
                      hintText: "Termin",
                      hintStyle: TextStyle(color: Colors.black)),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Divider(
                  color: Colors.blue,
                  height: 0.0,
                ),
              ),
              GestureDetector(
                child: Container(
                    height: 40,
                    color: Colors.deepOrange,
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            "Dienstleister",
                            style: TextStyle(

                                //Color(0xFFC2C2C2)
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        Icon(
                          CupertinoIcons.getIconData(0xf3d0),
                          color: Colors.black,
                        ),
                      ],
                    )),
                onTap: () {
                  FocusScope.of(context).requestFocus(new FocusNode());
                  setState(() {
                    _activeSelection = Select.Company;
                  });
                  _controller.setVisibility(true);

                  _controller.halfExpand();
                },
              ),
              Divider(
                color: Colors.blue,
                height: 0.0,
              ),
              SizedBox(
                height: 30,
              ),
              Divider(
                color: Colors.blue,
                height: 0.0,
              ),
              Container(
                color: Colors.deepOrange,
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 10.0, right: 10.0),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Zeitraum",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: RaisedButton(
                            child: Text("Datum"),
                            onPressed: () {
                              print("DATE");
                              setState(() {
                                _activeSelection = Select.Date;
                              });
                              _controller.halfExpand();
                            },
                          ),
                        ),
                        Expanded(
                            child: RaisedButton(
                          child: Text("Uhrzeit"),
                          onPressed: () {
                            print("TIME");
                            setState(() {
                              _activeSelection = Select.Time;
                            });
                            _controller.halfExpand();
                          },
                        ))
                      ],
                    )
                  ],
                ),
              ),
            ])));
  }

  Widget _selectCompany() {
    return Container(
      decoration: BoxDecoration(color: Colors.cyan),
      child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          controller: _scrollController,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(title: Text("Company $index"));
          },
          itemCount: 100),
    );
  }

  Widget _getUpperLayer() {
    switch (_activeSelection) {
      case Select.Company:
        return _selectCompany();
      case Select.Date:
        return Container(
          decoration: BoxDecoration(color: Colors.cyan),
          child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              controller: _scrollController,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(title: Text("DATE $index"));
              },
              itemCount: 100),
        );
      case Select.Time:
        return Container(
          decoration: BoxDecoration(color: Colors.cyan),
          child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              controller: _scrollController,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(title: Text("Time $index"));
              },
              itemCount: 100),
        );
    }
  }

  Widget _appBar() {
    return AppBar(
      centerTitle: true,
      title: Text("Neuer Termin"),
      leading: IconButton(
        icon: Icon(Icons.close),
        padding: EdgeInsets.zero,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      actions: <Widget>[
        CupertinoButton(
          child: Text("Erstellen"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}

enum Select { Company, Date, Time }
