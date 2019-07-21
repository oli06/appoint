import 'package:appoint/models/appoint.dart';
import 'package:appoint/models/company.dart';
import 'package:appoint/models/period.dart';
import 'package:appoint/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

String url = 'https://833e43e1.ngrok.io';
//String url = 'http://localhost:8000';

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

  Future<bool> postUserVerificationCode(int userId, String code) async {
    final response =
        await http.post('$url/user/$userId/verification', body: code);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }

    return false;
  }

  Future<List<Period>> getPeriodsForMonth(int companyId) async {
    final response = await http.get("$url/company/$companyId/periods/");

    if (response.statusCode == 200) {
      List<dynamic> list = json.decode(response.body);
      return list.map((entry) => Period.fromJson(entry)).toList();
    }

    return [];
  }

  Future<bool> registerUser(User user) async {
    final response = await http.post('$url/users',
        body: json.encode({
          'data': {'user': json.encode(user)}
        }));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }

    return false;
  }

  Future<bool> loginUser(String username, String password) async {
    final response = await http.post('$url/login',
        body: json.encode({
          'data': {'username': username, 'password': password}
        }));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }

    return false;
  }

  Future<bool> removeUserFavorites(
      int userId, List<int> favoriteCompanyIds) async {
    //theres is no multi http-delete, which is why we use http.post and list the ids inside body
    final response =
        await http.post('$url/user/$userId/companyfavorites/delete',
            body: json.encode({
              'data': {
                'ids': [favoriteCompanyIds],
              }
            }));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }

    return false;
  }

  Future<bool> addUserFavorite(int userId, int favoriteCompanyIds) async {
    final response = await http.post('$url/user/$userId/companyfavorites',
        body: json.encode({
          'data': {
            'ids': [favoriteCompanyIds],
          }
        }));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    }

    return false;
  }

  Future<List<Company>> getUserFavorites(List<int> companyIds) async {
    //FIXME: Mock Server cant handle ?id=xxx
    //thats why we use /compfav till then
    //format should be: $url/companies?id=1,2,3
    String ids = "id=";
    companyIds.forEach((id) => ids += "$id,");
    ids = ids.substring(0, ids.length - 1); //removing last ','

    final response = await http.get('$url/compfav');

    if (response.statusCode == 200) {
      List<dynamic> list = json.decode(response.body);
      return list.map((model) => Company.fromJson(model)).toList();
    }

    return [];
  }

  Future<User> getUser() async {
    final response = await http.get('$url/user/1');

    if (response.statusCode == 200) {
      dynamic user = json.decode(response.body);
      return User.fromJson(user);
    }

    return null;
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
    if (response.statusCode == 200) {
      List<dynamic> list = json.decode(response.body);
      return list.map((entry) => Period.fromJson(entry)).toList();
    }

    return [];
  }

  Future<List<Period>> getTimePeriods(int companyId, String time) async {
    time = "08-00";
    final response = await http.get('$url/company/$companyId/periods/$time');
    if (response.statusCode == 200) {
      List<dynamic> list = json.decode(response.body);
      return list.map((entry) => Period.fromJson(entry)).toList();
    }

    return [];
  }
}
