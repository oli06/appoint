

class Period {
  final DateTime start;
  final Duration duration;

  Period({this.start, this.duration});

  DateTime getPeriodEnd() {
    return start.add(duration);
  }

  Period.fromJson(Map<String, dynamic> json)
      : start = DateTime.parse(json['start']),
        duration = Duration(minutes: json['duration']);

  Map<String, dynamic> toJson() =>
    {
      'start': start.toIso8601String(),
      'duration': duration.inMinutes,
    };
}

class PeriodMap {
  final DateTime day;
  final List<Period>periods;

  PeriodMap({this.day, this.periods});

    PeriodMap.fromJson(Map<String, dynamic> json)
      : day = DateTime.fromMillisecondsSinceEpoch(json['day']),
      periods = json['periods'].map((p) => Period.fromJson(p)).toList();

}