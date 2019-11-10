// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Sync _$SyncFromJson(Map json) {
  return Sync(
    lastModified: json['lastModified'] == null
        ? null
        : DateTime.parse(json['lastModified'] as String),
    appointmentsLastModified: json['appointmentsLastModified'] == null
        ? null
        : DateTime.parse(json['appointmentsLastModified'] as String),
  );
}

Map<String, dynamic> _$SyncToJson(Sync instance) => <String, dynamic>{
      'lastModified': instance.lastModified?.toIso8601String(),
      'appointmentsLastModified':
          instance.appointmentsLastModified?.toIso8601String(),
    };
