import 'package:appoint/models/period.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dayresponse.g.dart';

@JsonSerializable()
class DayResponse {
  List<Period> periods = [];
  DateTime date;

  DayResponse({
    this.periods,
    this.date,
  });

  @override
  int get hashCode => periods.hashCode ^ date.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DayResponse &&
          runtimeType == other.runtimeType &&
          periods == other.periods &&
          date == other.date;

  factory DayResponse.fromJson(Map<String, dynamic> json) {
    return _$DayResponseFromJson(json);
  }

  Map<String, dynamic> toJson() => _$DayResponseToJson(this);
}
