// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Company _$CompanyFromJson(Map<String, dynamic> json) {
  return Company(
      id: json['id'] as String,
      isPartner: json['isPartner'] as bool,
      name: json['name'] as String,
      description: json['description'] as String,
      phone: json['phone'] as String,
      picture: json['picture'] as String,
      address: json['address'] == null
          ? null
          : Address.fromJson(json['address'] as Map<String, dynamic>),
      rating: (json['rating'] as num)?.toDouble(),
      category: _$enumDecodeNullable(_$CategoryEnumMap, json['category']));
}

Map<String, dynamic> _$CompanyToJson(Company instance) => <String, dynamic>{
      'id': instance.id,
      'isPartner': instance.isPartner,
      'name': instance.name,
      'description': instance.description,
      'phone': instance.phone,
      'picture': instance.picture,
      'address': instance.address,
      'rating': instance.rating,
      'category': _$CategoryEnumMap[instance.category]
    };

T _$enumDecode<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }
  return enumValues.entries
      .singleWhere((e) => e.value == source,
          orElse: () => throw ArgumentError(
              '`$source` is not one of the supported values: '
              '${enumValues.values.join(', ')}'))
      .key;
}

T _$enumDecodeNullable<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source);
}

const _$CategoryEnumMap = <Category, dynamic>{
  Category.ACCOUNTANT: 'ACCOUNTANT',
  Category.DOCTOR: 'DOCTOR',
  Category.OTHER: 'OTHER'
};
