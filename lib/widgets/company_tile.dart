import 'package:appoint/assets/company_icons_icons.dart';
import 'package:appoint/models/app_state.dart';
import 'package:appoint/models/company.dart';
import 'package:appoint/utils/ios_url_scheme.dart';
import 'package:appoint/utils/parse.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:location/location.dart';
import 'package:url_launcher/url_launcher.dart';

class CompanyTile extends StatelessWidget {
  final Company company;
  final Function onTap;

  CompanyTile({this.company, this.onTap});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, LocationData>(
      converter: (store) => store.state.userViewModel.currentLocation,
      builder: (context, data) => Slidable(
        actionPane: SlidableDrawerActionPane(),
        secondaryActions: <Widget>[
          IconSlideAction(
            caption: 'Favoriten',
            color: Color(0xfff7981c),
            icon: CompanyIcons.heart_empty,
            onTap: () {
              print("favorite");
            },
          ),
        ],
        actions: <Widget>[
          IconSlideAction(
            caption: 'Anrufen',
            color: Color(0xff1991eb),
            icon: CupertinoIcons.phone_solid,
            onTap: () {
              final noSpacePhoneNumber = UrlScheme.getTelUrl(company.phone);
              canLaunch(noSpacePhoneNumber).then((result) {
                if (result) {
                  launch(noSpacePhoneNumber);
                }
              });
            },
          )
        ],
        child: ListTile(
          onTap: onTap,
          /* leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                "${company.picture}",
              )), */
          title: Row(
            children: <Widget>[
              Text(
                "${company.name}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    "${company.category.toString().split('.').last}",
                    style: const TextStyle(
                        fontWeight: FontWeight.w200, fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
          isThreeLine: true,
          subtitle: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "${company.address.toStreetString()}",
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  if (data != null)
                    Row(
                      children: <Widget>[
                        Icon(Icons.compare_arrows),
                        Text(
                            "${Parse.calculateDistanceBetweenCoordinates(data.latitude, data.longitude, company.address.latitude, company.address.longitude).toStringAsFixed(1)}"),
                      ],
                    ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Text(
                      "${company.address.toCityString()}",
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.w500),
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.star,
                        color: Color(0xfff7981c),
                        size: 16,
                      ),
                      Text("${company.rating.toStringAsFixed(1)}"),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
