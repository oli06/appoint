import 'package:appoint/model/company.dart';
import 'package:appoint/model/period.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

String url = 'https://44fac7b0.ngrok.io';

class Service {
  Future<List<Company>> getCompanies() async {
    print("called now");
    final response = await http.get('$url/test');

    if (response.statusCode == 200) {
      List<dynamic> list = json.decode(response.body);
      return list.map((model) => Company.fromJson(model)).toList();
    }
    
    return null;
  }

  Future<List<Period>> getPeriods(String companyId) async {
    final response = await http.get('$url/$companyId');
    if(response.statusCode == 200) {
      List<dynamic> list = json.decode(response.body);
      return list.map((entry) => Period.fromJson(entry)).toList();
    }

    return null;
  }
}
