import 'package:appoint/assets/company_icons_icons.dart';
import 'package:appoint/models/company.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class CompanyTile extends StatelessWidget {
  final Company company;
  final Function onTap;

  CompanyTile({this.company, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Favoriten',
          color: Color(0xfff7981c),
          icon: CompanyIcons.heart_empty,
          onTap: () {print("favorite");},
        ),
      ],
      actions: <Widget>[
        IconSlideAction(
          caption: 'Anrufen',
          color: Color(0xff1991eb),
          icon: CupertinoIcons.phone_solid,
          onTap: () {
            //TODO:
          },
        )
      ],
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
            backgroundImage: NetworkImage(
          "${company.picture}",
        )),
        title: Text(
          "${company.name}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
        isThreeLine: true,
        subtitle: Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "${company.address.toString()}",
                style:
                    const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    "${company.category}",
                    style: const TextStyle(
                        fontWeight: FontWeight.w200, fontSize: 13),
                  ),
                ),
                Text("${company.rating}"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
