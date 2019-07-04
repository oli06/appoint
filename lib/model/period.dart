

class Period {
  final DateTime start;
  final Duration duration;

  Period({this.start, this.duration});

  DateTime getPeriodEnd() {
    return start.add(duration);
  }

  Period.fromJson(Map<String, dynamic> json)
      : start = DateTime.fromMillisecondsSinceEpoch(json['start']),
        duration = Duration(minutes: json['duration']);

  Map<String, dynamic> toJson() =>
    {
      'start': start.millisecondsSinceEpoch,
      'duration': duration,
    };
}
