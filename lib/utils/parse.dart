import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Parse {
  static final DateFormat dateWithWeekday = DateFormat("EEEE, dd.MM.yyyy");

  static final DateFormat dateOnly = DateFormat("dd.MM.yyyy");

  static final DateFormat hoursWithMinutes = DateFormat("HH:mm");

  static final DateFormat dateRequestFormat = DateFormat("yyyy-MM-dd");

  /// The last day of a given month
  static DateTime lastDayOfMonth(DateTime month) {
    var beginningNextMonth = (month.month < 12)
        ? new DateTime(month.year, month.month + 1, 1)
        : new DateTime(month.year + 1, 1, 1);
    return beginningNextMonth.subtract(new Duration(days: 1));
  }

  static TimeOfDay convertTimeString(String value) {
    if (value != null && value.length == 5) {
      List<String> data = value.split('-');
      return TimeOfDay(
          hour: int.tryParse(data[1]), minute: int.tryParse(data[1]));
    }

    return null;
  }

  static DateTime dateTimeToDateOnly(DateTime dateTime) {
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  static String convertTimeOfDay(TimeOfDay time) {
    String _addLeadingZeroIfNeeded(int value) {
      if (value < 10) return '0$value';
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
    return firstDate.year == secondDate.year &&
        firstDate.month == secondDate.month &&
        firstDate.day == secondDate.day;
  }

  static String convertDateDifferenceToReadable(DateTime now, DateTime future) {
    final duration = future.difference(now);
    if (duration.inDays < 2) {
      return "${duration.inHours} Stunden";
    } else {
      return "${duration.inDays} Tagen";
    }
  }

  static List<Widget> ratingToIconList(double rating) {
    List<Widget> icons = [];
    //TODO: refactor
    final starCountString = rating.toStringAsFixed(0);
    final int starCount = int.parse(starCountString);

    for (int i = 0; i < starCount; i++) {
      icons.add(Icon(
        Icons.star,
        color: Color(0xfff7981c),
      ));
    }

    for (var o = icons.length; o < 5; o++) {
      icons.add(Icon(
        Icons.star_border,
        color: Color(0xffc5d0ed),
      ));
    }

    return icons;
  }
}
