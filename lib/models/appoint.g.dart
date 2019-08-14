// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'appoint.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Appoint _$AppointFromJson(Map json) {
  return Appoint(
    title: json['title'] as String,
    company: json['company'] == null
        ? null
        : Company.fromJson((json['company'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
    period: json['period'] == null
        ? null
        : Period.fromJson((json['period'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
    description: json['description'] as String,
    id: json['id'] as int,
  );
}

Map<String, dynamic> _$AppointToJson(Appoint instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'company': instance.company,
      'period': instance.period,
      'description': instance.description,
    };
