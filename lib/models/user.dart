import 'package:appoint/models/address.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final bool isVerified;
  final DateTime birthday;
  final String phone;
  final Address address;

  List<int> favorites = [];

  User({
    this.id,
    this.firstName,
    this.lastName,
    this.email,
    this.isVerified,
    this.birthday,
    this.favorites,
    this.phone,
    this.address,
  });

  @override
  String toString() {
    return '$firstName $lastName';
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return _$UserFromJson(json);
  }

  Map<String, dynamic> toJson() => _$UserToJson(this);
}