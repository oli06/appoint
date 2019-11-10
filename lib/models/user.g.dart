// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map json) {
  return User(
    id: json['id'] as int,
    firstName: json['firstName'] as String,
    lastName: json['lastName'] as String,
    email: json['email'] as String,
    isVerified: json['isVerified'] as bool,
    birthday: json['birthday'] == null
        ? null
        : DateTime.parse(json['birthday'] as String),
    favorites: (json['favorites'] as List)?.map((e) => e as int)?.toList(),
    phone: json['phone'] as String,
    address: json['address'] == null
        ? null
        : Address.fromJson((json['address'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
  );
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'isVerified': instance.isVerified,
      'birthday': instance.birthday?.toIso8601String(),
      'phone': instance.phone,
      'address': instance.address,
      'favorites': instance.favorites,
    };
