import 'package:appoint/models/address.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final int id;
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
  int get hashCode =>
      id.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      email.hashCode ^
      isVerified.hashCode ^
      birthday.hashCode ^
      favorites.hashCode ^
      phone.hashCode ^
      address.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          firstName == other.firstName &&
          lastName == other.lastName &&
          email == other.email &&
          isVerified == other.isVerified &&
          birthday == other.birthday &&
          favorites == other.favorites &&
          phone == other.phone &&
          address == other.address &&
          id == other.id;

  @override
  String toString() {
    return '$firstName $lastName';
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return _$UserFromJson(json);
  }

  Map<String, dynamic> toJson() => _$UserToJson(this);
}
