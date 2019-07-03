import 'package:flutter/material.dart';

class Parse {
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
}
