import 'package:appoint/models/appoint.dart';
import 'package:appoint/models/company.dart';
import 'package:appoint/models/period.dart';
import 'package:flutter/material.dart';

abstract class Repository {
  Future<List<Company>> getCompanies();
  Future<List<Appoint>> getAppointments(int index);
  Future<List<Period>> getDatePeriods(int companyId, DateTime date);
  Future<List<Period>> getTimePeriods(int companyId, TimeOfDay time);
}