import 'package:appoint/models/period.dart';
import 'package:json_annotation/json_annotation.dart';

part 'dayresponse.g.dart';

@JsonSerializable()
class DayResponse {
  List<Period> periods = [];
  DateTime date;

  DayResponse({this.periods, this.date});

  factory DayResponse.fromJson(Map<String, dynamic> json) {
    return _$DayResponseFromJson(json);
  }

  Map<String, dynamic> toJson() => _$DayResponseToJson(this);
}
