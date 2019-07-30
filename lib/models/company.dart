import 'package:appoint/models/address.dart';
import 'package:json_annotation/json_annotation.dart';

part 'company.g.dart';

@JsonSerializable()
class Company {
  int id;
  String name;
  String picture;
  Address address;
  double rating;
  int category;
  bool isPartner;
  String description;
  String phone;

  Company({
    this.id,
    this.name,
    this.picture,
    this.address,
    this.rating,
    this.category,
    this.isPartner,
    this.description,
    this.phone,
  });

  factory Company.fromJson(Map<String, dynamic> json) {
    return _$CompanyFromJson(json);
  }

  Map<String, dynamic> toJson() => _$CompanyToJson(this);
}

enum CompanyVisibilityFilter {
  all,
  favorites,
}
