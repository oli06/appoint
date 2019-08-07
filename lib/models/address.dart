import 'package:json_annotation/json_annotation.dart';

part 'address.g.dart';

@JsonSerializable()
class Address {
  String street;
  String houseNumber;
  String city;
  String postal;

  double latitude;
  double longitude;

  Address({
    this.street,
    this.houseNumber,
    this.city,
    this.postal,
    this.latitude,
    this.longitude,
  });

  @override
  int get hashCode =>
      street.hashCode ^
      houseNumber.hashCode ^
      city.hashCode ^
      postal.hashCode ^
      latitude.hashCode ^
      longitude.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Address &&
          runtimeType == other.runtimeType &&
          street == other.street &&
          houseNumber == other.houseNumber &&
          city == other.city &&
          postal == other.postal &&
          latitude == other.latitude &&
          longitude == other.longitude;

  @override
  String toString() {
    return "$street $houseNumber - $postal $city";
  }

  String toStringWithComma() {
    return "$street $houseNumber, $postal $city";
  }

  String toCityString() {
    return "$postal $city";
  }

  String toStreetString() {
    return "$street $houseNumber";
  }

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);

  Map<String, dynamic> toJson() => _$AddressToJson(this);
}
