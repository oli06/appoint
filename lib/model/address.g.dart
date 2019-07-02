// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Address _$AddressFromJson(Map<String, dynamic> json) {
  return Address(
      street: json['street'] as String,
      houseNumber: json['houseNumber'] as int,
      city: json['city'] as String,
      zip: json['zip'] as int);
}

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
      'street': instance.street,
      'houseNumber': instance.houseNumber,
      'city': instance.city,
      'zip': instance.zip
    };
