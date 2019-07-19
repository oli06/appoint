import 'package:appoint/models/company.dart';
import 'package:appoint/models/period.dart';
import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';

part 'appoint.g.dart';

@JsonSerializable()
class Appoint {
  int id;
  final String title;
  final Company company;
  final Period period;
  final String description;

  Appoint({
    @required this.title,
    @required this.company,
    @required this.period,
    this.description = "",
    this.id,
  });

    factory Appoint.fromJson(Map<String, dynamic> json) {
    return _$AppointFromJson(json);
  }

  Map<String, dynamic> toJson() => _$AppointToJson(this);
}
