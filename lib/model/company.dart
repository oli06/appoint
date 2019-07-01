import 'package:appoint/model/address.dart';

class Company {
  String id;
  bool isPartner;
  String name;
  String description;
  String phone;
  String picture;
  Address address;
  double rating;
  String category; //TODO FIX TO INT

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

  Company.fromJson(Map<String, dynamic> json)
      : address = Address.fromJson(json['address']),
        category = json['category'],
        description = json['description'],
        id = json['id'],
        isPartner = json['isPartner'],
        name = json['name'],
        phone = json['phone'],
        picture = json['picture'],
        rating = double.parse(json['rating']);
}

enum Category { ACCOUNTANT, DOCTOR, OTHER }
