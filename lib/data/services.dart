import 'package:appoint/model/company.dart';
import 'package:appoint/model/period.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

String url = 'https://4280813e.ngrok.io';

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
    final response = await http.get('$url/company/$companyId/day/$date');
    if(response.statusCode == 200) {
      List<dynamic> list = json.decode(response.body);
      return list.map((entry) => Period.fromJson(entry)).toList();
    }

    return null;
  }

    Future<List<Period>> getTimePeriods(int companyId, String time) async {
    time = "08-00";
    final response = await http.get('$url/company/$companyId/periods/$time');
    if(response.statusCode == 200) {
      List<dynamic> list = json.decode(response.body);
      return list.map((entry) => Period.fromJson(entry)).toList();
    }

    return null;
  }
}
