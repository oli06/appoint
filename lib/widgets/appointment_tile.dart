import 'package:appoint/models/appoint.dart';
import 'package:appoint/utils/parse.dart';
import 'package:appoint/widgets/period_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class AppointmentTile extends StatelessWidget {
  final Appoint appoint;
  final Function onTap;

  AppointmentTile({this.appoint, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Verschieben',
          color: Color(0xfff7981c),
          icon: Icons.watch_later,
          onTap: () {
            print("favorite");
          },
        ),
        IconSlideAction(
          caption: 'Absagen',
          color: Colors.red,
          icon: Icons.cancel,
          onTap: () {
            print("favorite");
          },
        ),
      ],
      actions: <Widget>[
        IconSlideAction(
          caption: 'Route',
          color: Color(0xff1991eb),
          icon: Icons.map,
          onTap: () {
            //TODO:
          },
        )
      ],
      child: GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 60,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 4.0, top: 4),
                  child: Align(
                      alignment: Alignment.topCenter,
                      child: PeriodBar(
                        period: appoint.period,
                      )),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          appoint.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Color(0xff333f52)),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                "${Parse.hoursWithMinutes.format(appoint.period.start.toUtc())} - ${Parse.hoursWithMinutes.format(appoint.period.getPeriodEnd().toUtc())}",
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                            Text(appoint.company.category
                                .toString()
                                .split(".")
                                .last),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(appoint.company.name),
                            Text(appoint.company.address.toCityString()),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Icon(Icons.arrow_forward_ios),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
