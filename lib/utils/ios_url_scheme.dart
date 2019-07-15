import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlScheme {
  static String getTelUrl(String phoneNumber) {
    return "tel:${phoneNumber.replaceAll(RegExp(r" "), '')}";
  }

  static void openRoute(double startLat, double startLon, double destinationLat,
      double destinationLon) async {
    String googleUrl =
        'comgooglemaps://?saddr=${startLat.toString()},${startLon.toString()}&daddr=${destinationLat.toString()},${destinationLon.toString()}&directionsmode=driving';
    String appleUrl =
        'https://maps.apple.com/?saddr=${startLat.toString()},${startLon.toString()}&daddr=${destinationLat.toString()},${destinationLon.toString()}&dirflg=d';
    if (await canLaunch("comgooglemaps://")) {
      print('launching com googleUrl');
      await launch(googleUrl);
    } else if (await canLaunch(appleUrl)) {
      print('launching apple url');
      await launch(appleUrl);
    } else {
      throw 'Could not launch url';
      //TODO: NYI
    }
  }

  static String getGoogleMapsRouteUrl(double startLat, double startLon,
      double destinationLat, double destinationLon) {
    return 'comgooglemaps://?saddr=${startLat.toString()},${startLon.toString()}&daddr=${destinationLat.toString()},${destinationLon.toString()}&directionsmode=driving';
  }

  static String getAppleMapsRouteUrl(double startLat, double startLon,
      double destinationLat, double destinationLon) {
    return 'https://maps.apple.com/?saddr=${startLat.toString()},${startLon.toString()}&daddr=${destinationLat.toString()},${destinationLon.toString()}&dirflg=d';
  }

  static Future<bool> isGoogleMapsAvailable() async {
    return canLaunch("comgooglemaps://");
  }

  static Future<bool> isAppleMapsAvailable() async {
    return canLaunch("maps://");
  }

  static void buildRouteCupertinoActionSheet(
    BuildContext context,
    double startLat,
    double startLon,
    double destinationLat,
    double destinationLon,
  ) async {
    List<Widget> actions = [];

    if (await UrlScheme.isGoogleMapsAvailable())
      actions.add(
        CupertinoActionSheetAction(
            child: Text("Google Maps"),
            onPressed: () {
              launch(UrlScheme.getGoogleMapsRouteUrl(
                startLat,
                startLon,
                destinationLat,
                destinationLon,
              ));
              Navigator.pop(context);
            }),
      );

    if (await UrlScheme.isAppleMapsAvailable())
      actions.add(CupertinoActionSheetAction(
          child: Text("Apple Maps (Karten)"),
          onPressed: () {
            launch(UrlScheme.getAppleMapsRouteUrl(
              startLat,
              startLon,
              destinationLat,
              destinationLon,
            ));
            Navigator.pop(context);
          }));

    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: actions,
        cancelButton: CupertinoActionSheetAction(
          child: Text("Abbrechen"),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }
}
