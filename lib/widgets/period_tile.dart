import 'package:appoint/models/period.dart';
import 'package:appoint/utils/parse.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PeriodTile extends StatelessWidget {
  final Period period;
  final Function onTap;

  PeriodTile({this.period, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      title: Text(
        "${Parse.hoursWithMinutes.format(period.start.toUtc())} - ${Parse.hoursWithMinutes.format(period.getPeriodEnd().toUtc())}",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
      ),
    );
  }
}
