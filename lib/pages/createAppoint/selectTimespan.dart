import 'package:appoint/widgets/navBar.dart';
import 'package:flutter/material.dart';

class SelectTimespan extends StatefulWidget {
  final bool isDateMode;

  SelectTimespan({this.isDateMode});

  @override
  _SelectTimespanState createState() => _SelectTimespanState();
}

class _SelectTimespanState extends State<SelectTimespan> {
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
              secondHeader: "Zeitraum wählen",
              endingWidget: Container(height: 0,),
            )
          ],
        ),
      ),
    );
  }
}
