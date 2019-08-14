// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dayresponse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DayResponse _$DayResponseFromJson(Map json) {
  return DayResponse(
    periods: (json['periods'] as List)
        ?.map((e) => e == null
            ? null
            : Period.fromJson((e as Map)?.map(
                (k, e) => MapEntry(k as String, e),
              )))
        ?.toList(),
    date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
  );
}

Map<String, dynamic> _$DayResponseToJson(DayResponse instance) =>
    <String, dynamic>{
      'periods': instance.periods,
      'date': instance.date?.toIso8601String(),
    };
