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

  factory UserAccount.fromJson(Map<String, dynamic> json) {
    return _$UserAccountFromJson(json);
  }

  Map<String, dynamic> toJson() => _$UserAccountToJson(this);
}
