import 'package:json_annotation/json_annotation.dart';

part 'useraccount.g.dart';

@JsonSerializable()
class UserAccount {
  final String password;
  final String firstName;
  final String lastName;
  final String email;
  final DateTime birthday;
  final String phone;

  UserAccount({
    this.password,
    this.firstName,
    this.lastName,
    this.email,
    this.birthday,
    this.phone,
  });

  @override
  int get hashCode =>
      password.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      email.hashCode ^
      birthday.hashCode ^
      phone.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAccount &&
          runtimeType == other.runtimeType &&
          password == other.password &&
          firstName == other.firstName &&
          email == other.email &&
          birthday == other.birthday &&
          phone == other.phone &&
          lastName == other.lastName;

  factory UserAccount.fromJson(Map<String, dynamic> json) {
    return _$UserAccountFromJson(json);
  }

  Map<String, dynamic> toJson() => _$UserAccountToJson(this);
}
