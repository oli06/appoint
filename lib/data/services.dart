import 'package:appoint/model/company.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

String url = 'http://localhost:8000';

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
}
