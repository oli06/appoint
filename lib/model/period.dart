import 'package:appoint/utils/parse.dart';
import 'package:flutter/material.dart';

class Period {
  TimeOfDay time;
  Duration duration;

  Period({this.time, this.duration});

      Period.fromJson(Map<String, dynamic> json)
      : time = Parse.convertTimeString(json['date']),
        duration = Duration(minutes: json['duration']);

  Map<String, dynamic> toJson() =>
    {
      'date': time,
      'duration': duration,
    };
}
