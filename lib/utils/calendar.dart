import 'package:appoint/models/company.dart';
import 'package:device_calendar/device_calendar.dart' as pubdev;
import 'package:flutter/services.dart';

class Calendar {
  pubdev.DeviceCalendarPlugin _deviceCalendarPlugin;
  List<pubdev.Calendar> _calendars;

  Calendar() {
    _deviceCalendarPlugin = pubdev.DeviceCalendarPlugin();
    retrieveCalendars();
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

  Future<pubdev.Result<List<pubdev.Event>>> retrieveCalendarEvents(
      String calendarId, DateTime date) async {
    try {
      final day = DateTime(date.year, date.month, date.day);
      final retrieveEventsParams = new pubdev.RetrieveEventsParams(
          startDate: day, endDate: day.add(Duration(days: 1)));
      return _deviceCalendarPlugin.retrieveEvents(
          calendarId, retrieveEventsParams);
    } catch (e) {
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

      final notes = description != null ? "Notizen: $description" : "";
      final locationCoordinates =
          company.address.latitude != null && company.address.longitude != null
              ? "${company.address.latitude},${company.address.longitude}"
              : "";

      final event = pubdev.Event(calendarId)
        ..title = title
        ..description =
            "Unternehmen: ${company.name} \nTelefon: ${company.phone}\n$notes"
        ..start = dateTime
        ..end = dateTime.add(duration)
        ..location = company.address.toStringWithComma()
        ..locationCoordinates = locationCoordinates;

      final calendarResult =
          await _deviceCalendarPlugin.createOrUpdateEvent(event);
      return calendarResult.isSuccess && calendarResult.data.isNotEmpty;
    } on PlatformException catch (e) {
      print(e);
      return false;
    }
  }
}
