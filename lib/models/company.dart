import 'package:appoint/models/address.dart';
import 'package:json_annotation/json_annotation.dart';

part 'company.g.dart';

@JsonSerializable()
class Company {
  int id;
  String name;
  Address address;
  double rating;
  int category;
  bool isPartner;
  String description;
  String avatar;
  String phone;

  Company({
    this.id,
    this.name,
    this.address,
    this.rating,
    this.category,
    this.isPartner,
    this.description,
    this.avatar,
    this.phone,
  });

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      address.hashCode ^
      rating.hashCode ^
      category.hashCode ^
      isPartner.hashCode ^
      description.hashCode ^
      avatar.hashCode ^
      phone.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Company &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          address == other.address &&
          rating == other.rating &&
          category == other.category &&
          isPartner == other.isPartner &&
          description == other.description &&
          avatar == other.avatar &&
          phone == other.phone;

  factory Company.fromJson(Map<String, dynamic> json) {
    return _$CompanyFromJson(json);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
      };
}
