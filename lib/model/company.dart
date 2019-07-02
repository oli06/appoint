import 'package:appoint/model/address.dart';
import 'package:json_annotation/json_annotation.dart';

part 'company.g.dart';

@JsonSerializable()
class Company {
  String id;
  bool isPartner;
  String name;
  String description;
  String phone;
  String picture;
  Address address;
  double rating;
  Category category; //TODO FIX TO INT

  Company({
    this.id,
    this.isPartner,
    this.name,
    this.description,
    this.phone,
    this.picture,
    this.address,
    this.rating,
    this.category,
  });

  /* Company.fromJson(Map<String, dynamic> json)
      : address = Address.fromJson(json['address']),
        category = json['category'],
        description = json['description'],
        id = json['id'],
        isPartner = json['isPartner'],
        name = json['name'],
        phone = json['phone'],
        picture = json['picture'],
        rating = double.parse(json['rating']); */

      factory Company.fromJson(Map<String, dynamic> json) => _$CompanyFromJson(json);

  Map<String, dynamic> toJson() => _$CompanyToJson(this);
}

enum Category { ACCOUNTANT, DOCTOR, OTHER }

enum CompanyVisibilityFilter {
  all, favorites, category
}