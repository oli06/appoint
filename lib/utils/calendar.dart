import 'package:appoint/models/address.dart';
import 'package:device_calendar/device_calendar.dart' as pubdev;
import 'package:flutter/services.dart';

class Calendar {
  pubdev.DeviceCalendarPlugin _deviceCalendarPlugin;
  List<pubdev.Calendar> _calendars;

  Calendar() {
    _deviceCalendarPlugin = pubdev.DeviceCalendarPlugin();
    _retrieveCalendars();
  }

  void _retrieveCalendars() async {
    try {
      var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();
      if (permissionsGranted.isSuccess && !permissionsGranted.data) {
        permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
        if (!permissionsGranted.isSuccess || !permissionsGranted.data) {
          return;
        }
      }

      final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();
      _calendars = calendarsResult?.data;
    } on PlatformException catch (e) {
      print(e);
    }
  }

  Future<bool> createNativeCalendarEvent(
      String calendarId,
      DateTime dateTime,
      String title,
      Duration duration,
      String description,
      Address locationAddress) async {
    final event = pubdev.Event(calendarId)
      ..title = title
      ..description = description
      ..start = dateTime
      ..end = dateTime.add(duration)
      ..location = locationAddress.toStringWithComma();

    final calendarResult =
        await _deviceCalendarPlugin.createOrUpdateEvent(event);
    return calendarResult.isSuccess && calendarResult.data.isNotEmpty;
  }
}
