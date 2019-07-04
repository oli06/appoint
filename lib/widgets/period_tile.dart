import 'package:appoint/model/period.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class PeriodTile extends StatelessWidget {
  final Period period;
  final Function onTap;

  PeriodTile({this.period, this.onTap});

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat("HH:mm");

    return ListTile(
      onTap: onTap,
      title: Text(
        "${formatter.format(period.start.toUtc())} - ${formatter.format(period.getPeriodEnd().toUtc())}",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
      ),
    );
  }
}
