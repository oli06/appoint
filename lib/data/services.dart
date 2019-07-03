import 'package:appoint/model/company.dart';
import 'package:appoint/model/day_space.dart';
import 'package:appoint/model/period.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

String url = 'https://44fac7b0.ngrok.io';

class Service {
  Future<List<Company>> getCompanies() async {
    print("called now");
    final response = await http.get('$url/companies');

    if (response.statusCode == 200) {
      List<dynamic> list = json.decode(response.body);
      return list.map((model) => Company.fromJson(model)).toList();
    }
    
    return null;
  }

  Future<List<Period>> getDatePeriods(int companyId, String date) async {
    companyId = 1;
    final response = await http.get('$url/company/$companyId/periods/$date');
    if(response.statusCode == 200) {
      List<dynamic> list = json.decode(response.body);
      return list.map((entry) => Period.fromJson(entry)).toList();
    }

    return null;
  }

    Future<List<Period>> getTimePeriods(int companyId, String time) async {
    companyId = 1;
    final response = await http.get('$url/company/$companyId/periods/$time');
    if(response.statusCode == 200) {
      List<dynamic> list = json.decode(response.body);
      return list.map((entry) => Period.fromJson(entry)).toList();
    }

    return null;
  }
}
