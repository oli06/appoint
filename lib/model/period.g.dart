// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'period.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Period _$PeriodFromJson(Map<String, dynamic> json) {
  return Period(
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String),
      duration: json['duration'] == null
          ? null
          : Duration(microseconds: json['duration'] as int));
}

Map<String, dynamic> _$PeriodToJson(Period instance) => <String, dynamic>{
      'date': instance.date?.toIso8601String(),
      'duration': instance.duration?.inMicroseconds
    };
