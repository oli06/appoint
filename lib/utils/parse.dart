import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Parse {
   static final DateFormat dateWithWeekday = DateFormat("EEEE, dd.MM.yyyy");

   static final DateFormat dateOnly = DateFormat("dd.MM.yyyy");

   static final DateFormat hoursWithMinutes = DateFormat("HH:mm");

  static TimeOfDay convertTimeString(String value) {
    if (value != null && value.length == 5) {
      List<String> data = value.split('-');
      return TimeOfDay(
          hour: int.tryParse(data[1]), minute: int.tryParse(data[1]));
    }

    return null;
  }

  static String convertTimeOfDay(TimeOfDay time) {
    String _addLeadingZeroIfNeeded(int value) {
      if (value < 10)
        return '0$value';
      return value.toString();
    }

    final String hourLabel = _addLeadingZeroIfNeeded(time.hour);
    final String minuteLabel = _addLeadingZeroIfNeeded(time.minute);
    return "$hourLabel-$minuteLabel";
  }

  static String convertDateToPeriodDate(DateTime date) {
    //2019-07-23
    return "${date.year}-${date.month}-${date.day}";
  }

  static bool sameDay(DateTime firstDate, DateTime secondDate) {
    return firstDate.year == secondDate.year && firstDate.month == secondDate.month && firstDate.day == secondDate.day;
  }

  static String convertDateDifferenceToReadable(DateTime now, DateTime future) {
    final duration = future.difference(now);
    if(duration.inDays < 2) {
      return "${duration.inHours} Studen";
    } else {
      return "${duration.inDays} Tagen";
    }
  }


}
