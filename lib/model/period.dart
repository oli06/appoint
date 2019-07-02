import 'package:json_annotation/json_annotation.dart';

part 'period.g.dart';

@JsonSerializable()
class Period {
  DateTime date;
  Duration duration;

  Period({this.date, this.duration});

    factory Period.fromJson(Map<String, dynamic> json) => _$PeriodFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$PeriodToJson(this);
}

enum PeriodMode {
  DATE,
  TIME,
}