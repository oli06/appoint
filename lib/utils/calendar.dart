import 'package:appoint/models/company.dart';
import 'package:device_calendar/device_calendar.dart' as pubdev;
import 'package:flutter/services.dart';

class Calendar {
  pubdev.DeviceCalendarPlugin _deviceCalendarPlugin;
  List<pubdev.Calendar> _calendars;

  Calendar() {
    _deviceCalendarPlugin = pubdev.DeviceCalendarPlugin();
  }

  Future<List<pubdev.Calendar>> retrieveCalendars() async {
    try {
      var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();
      if (permissionsGranted.isSuccess && !permissionsGranted.data) {
        permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
        if (!permissionsGranted.isSuccess || !permissionsGranted.data) {
          return null;
        }
      }

      final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
      _calendars = calendarsResult?.data;
      return Future.value(_calendars);
    } on PlatformException catch (e) {
      print(e);
      return null;
    }
  }

  Future<bool> createNativeCalendarEvent(
      String calendarId,
      DateTime dateTime,
      String title,
      Duration duration,
      String description,
      Company company) async {
    try {
      var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();
      if (permissionsGranted.isSuccess && !permissionsGranted.data) {
        permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
        if (!permissionsGranted.isSuccess || !permissionsGranted.data) {
          return false;
        }
      }

      final event = pubdev.Event(calendarId)
        ..title = title
        ..description =
            "Unternehmen: ${company.name} \nTelefon: ${company.phone}\nNotizen: $description"
        ..start = dateTime
        ..end = dateTime.add(duration)
        ..location = company.address.toStringWithComma()
        ..locationCoordinates =
            "${company.address.latitude},${company.address.longitude}";

      final calendarResult =
          await _deviceCalendarPlugin.createOrUpdateEvent(event);
      return calendarResult.isSuccess && calendarResult.data.isNotEmpty;
    } on PlatformException catch (e) {
      print(e);
      return false;
    }
  }
}
