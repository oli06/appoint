import 'package:appoint/models/appoint.dart';
import 'package:appoint/models/company.dart';
import 'package:appoint/models/period.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

String url = 'https://3e01132c.ngrok.io';

class Api {
  Future<List<Company>> getCompanies() async {
    print("called now");
    final response = await http.get('$url/companies');

    if (response.statusCode == 200) {
      List<dynamic> list = json.decode(response.body);
      return list.map((model) => Company.fromJson(model)).toList();
    }
    
    return [];
  }

  Future<List<Appoint>> getAppointments() async {
    print("called now");
    final response = await http.get('$url/user/1/appointments');

    if (response.statusCode == 200) {
      List<dynamic> list = json.decode(response.body);
      return list.map((model) => Appoint.fromJson(model)).toList();
    }
    
    return [];
  }

  Future<List<Period>> getDatePeriods(int companyId, String date) async {
    companyId = 1;
    final response = await http.get('$url/company/$companyId/day/$date');
    if(response.statusCode == 200) {
      List<dynamic> list = json.decode(response.body);
      return list.map((entry) => Period.fromJson(entry)).toList();
    }

    return [];
  }

    Future<List<Period>> getTimePeriods(int companyId, String time) async {
    time = "08-00";
    final response = await http.get('$url/company/$companyId/periods/$time');
    if(response.statusCode == 200) {
      List<dynamic> list = json.decode(response.body);
      return list.map((entry) => Period.fromJson(entry)).toList();
    }

    return [];
  }
}
