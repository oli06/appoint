class Address {
  String street;
  int houseNumber;
  String city;
  int zip;

  Address({
    this.street,
    this.houseNumber,
    this.city,
    this.zip,
  });

  @override
  String toString() {
    return "$street $houseNumber - $zip $city";
  }

  Address.fromJson(Map<String, dynamic> json)
      : street = json['street'],
        houseNumber = json['houseNumber'],
        city = json['city'],
        zip = json['zip'];
}
