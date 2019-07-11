import 'package:json_annotation/json_annotation.dart';

part 'address.g.dart';

@JsonSerializable()
class Address {
  String street;
  String houseNumber;
  String city;
  int zip;

  double latitude;

  double longitude;

  Address(
      {this.street,
      this.houseNumber,
      this.city,
      this.zip,
      this.latitude,
      this.longitude});

  @override
  String toString() {
    return "$street $houseNumber - $zip $city";
  }

  String toCityString() {
    return "$zip $city";
  }

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);

  Map<String, dynamic> toJson() => _$AddressToJson(this);
}
