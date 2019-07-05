import 'package:appoint/models/company.dart';
import 'package:appoint/models/period.dart';
import 'package:flutter/widgets.dart';

class Appoint {
  final String title;
  final Company company;
  final Period period;
  final String description;

  const Appoint({
    @required this.title,
    @required this.company,
    @required this.period,
    this.description = "",
  });
}
