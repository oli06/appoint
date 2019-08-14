// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Address _$AddressFromJson(Map json) {
  return Address(
    street: json['street'] as String,
    houseNumber: json['houseNumber'] as String,
    city: json['city'] as String,
    postal: json['postal'] as String,
    latitude: (json['latitude'] as num)?.toDouble(),
    longitude: (json['longitude'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'street': instance.street,
      'houseNumber': instance.houseNumber,
      'city': instance.city,
      'postal': instance.postal,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
