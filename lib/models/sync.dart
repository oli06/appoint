import 'package:json_annotation/json_annotation.dart';

part 'sync.g.dart';

@JsonSerializable()
class Sync {
  final DateTime lastModified;
  final DateTime appointmentsLastModified;

  Sync({
    this.lastModified,
    this.appointmentsLastModified,
  });

  factory Sync.fromJson(Map<String, dynamic> json) {
    return _$SyncFromJson(json);
  }
}
