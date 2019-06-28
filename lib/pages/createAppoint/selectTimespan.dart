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
    return Container(
      child: Center(
        child: Text("Select Timespan"),
      ),
    );
  }
}
