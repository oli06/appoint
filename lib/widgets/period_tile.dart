import 'package:appoint/models/period.dart';
import 'package:appoint/utils/parse.dart';
import 'package:appoint/widgets/icon_circle_gradient.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PeriodTile extends StatelessWidget {
  final Period period;
  final Function onTap;
  final Widget trailing;

  PeriodTile({
    this.period,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          color: Colors
              .transparent, //make background transparent to use gesture detector on whole tile
          child: Row(
            children: <Widget>[
              IconCircleGradient.periodIndicator(
                  period.duration.inMinutes / 60),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  "${Parse.hoursWithMinutes.format(period.start)} - ${Parse.hoursWithMinutes.format(period.getPeriodEnd())}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
              if (trailing != null)
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: trailing,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
