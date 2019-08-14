// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Company _$CompanyFromJson(Map json) {
  return Company(
    id: json['id'] as int,
    name: json['name'] as String,
    address: json['address'] == null
        ? null
        : Address.fromJson((json['address'] as Map)?.map(
            (k, e) => MapEntry(k as String, e),
          )),
    rating: (json['rating'] as num)?.toDouble(),
    category: json['category'] as int,
    isPartner: json['isPartner'] as bool,
    description: json['description'] as String,
    avatar: json['avatar'] as String,
    phone: json['phone'] as String,
  );
}

Map<String, dynamic> _$CompanyToJson(Company instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'rating': instance.rating,
      'category': instance.category,
      'isPartner': instance.isPartner,
      'description': instance.description,
      'avatar': instance.avatar,
      'phone': instance.phone,
    };
