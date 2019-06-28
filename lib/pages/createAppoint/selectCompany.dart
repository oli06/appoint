import 'package:appoint/base/navBar.dart';
import 'package:flutter/material.dart';

class SelectCompany extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SelectCompanyState();
  }
}

class SelectCompanyState extends State<SelectCompany> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            NavBar(
              "Neuer Termin",
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              secondHeader: "Unternehmen auswählen",
              endingWidget: Container(height: 0,),
            )
          ],
        ),
      ),
    );
  }

 int currentlySelected = 0;
  String dropdownValue = "Arzt";

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

  /*
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
  */
}
