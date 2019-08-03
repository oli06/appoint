import 'dart:io';

import 'package:appoint/models/appoint.dart';
import 'package:appoint/models/category.dart';
import 'package:appoint/models/company.dart';
import 'package:appoint/models/day.dart';
import 'package:appoint/models/dayresponse.dart';
import 'package:appoint/models/period.dart';
import 'package:appoint/models/user.dart';
import 'package:appoint/models/useraccount.dart';
import 'package:appoint/utils/parse.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

// String url = 'https://ca6b821c.ngrok.io';
String baseUrl = "https://appointservice.azurewebsites.net/";
String accessPoint = "api/";
String url = baseUrl + accessPoint;
//String url = 'http://localhost:8000';

class Api {
  String token;

  Api({this.token});

  Future<List<Company>> getCompanies(String token) async {
    final response = await http.get('$url/companies',
        headers: {HttpHeaders.authorizationHeader: "bearer $token"});

    if (response.statusCode == 200) {
      List<dynamic> list = json.decode(response.body);
      return list.map((model) => Company.fromJson(model)).toList();
    }

    return [];
  }

  Future<List<Category>> getCategories(String token) async {
    final response = await http.get('$url/categories',
        headers: {HttpHeaders.authorizationHeader: "bearer $token"});

    if (response.statusCode == 200) {
      List<dynamic> list = json.decode(response.body);
      return list.map((c) => Category.fromJson(c)).toList();
    }

    return [];
  }

  Future<bool> postUserVerificationCode(
      String userId, String code, String token) async {
    final response = await http.post(
      '$url/users/$userId/verify',
      headers: {
        "Content-Type": "application/json",
        HttpHeaders.authorizationHeader: "bearer $token"
      },
      body: json.encode(code),
    );

    if (response.statusCode == 200) {
      return true;
    }

    return false;
  }

  Future<Map<DateTime, List<Period>>> getPeriods(
      int companyId, DateTime first, DateTime last) async {
    final response = await http.get(
      "$url/companies/$companyId/periods?start=${Parse.dateRequestFormat.format(first)}&end=${Parse.dateRequestFormat.format(last)}",
      headers: {HttpHeaders.authorizationHeader: "bearer $token"},
    );

    Map<DateTime, List<Period>> map = {};
    if (response.statusCode == 200) {
      final List<dynamic> list = json.decode(response.body);

      list.forEach((day) {
        DayResponse dayObj = DayResponse.fromJson(day);

        map[dayObj.date] = dayObj.periods;
      });

      return map;
    }

    return {};
  }

/*   Future<Map<DateTime, List<Period>>> getPeriodsForMonth(
      int companyId, DateTime month, String token) async {
    final response = await http.get(
      "$url/companies/$companyId/periods/${Parse.dateRequestFormat.format(month)}",
      headers: {HttpHeaders.authorizationHeader: "bearer $token"},
    );

    Map<DateTime, List<Period>> map = {};
    if (response.statusCode == 200) {
      final List<dynamic> list = json.decode(response.body);

      list.forEach((day) {
        DayResponse dayObj = DayResponse.fromJson(day);
        /* final Day<Period> dayObj = new Day<Period>(
            date: DateTime.parse(day['date']),
            events:
                day['periods'].map((model) => Period.fromJson(model)).toList()); */

        map[dayObj.date] = dayObj.periods;
      });

      //var abc = list.map((entry) => {});

      return map;
    }

    return {};
  } */

  Future<http.Response> register(UserAccount user) async {
    final jsonString = user.toJson();
    final response = await http.post('$url/users/register', body: jsonString);

    return response;
  }

  Future<http.Response> login(String username, String password) async {
    print("login request $username, pw: $password");
    final body = {
      "grant_type": "password",
      "username": username,
      "password": password
    };
    final url = baseUrl + "token";
    return await http.post(url, body: body);
  }

  Future<bool> removeUserFavorites(
      String userId, List<int> companyIds, String token) async {
    //theres is no multi http-delete, which is why we use http.post and list the ids inside body
    final response = await http.post(
      '$url/users/$userId/favorites/delete',
      headers: {
        "Content-Type": "application/json",
        HttpHeaders.authorizationHeader: "bearer $token"
      },
      body: json.encode(companyIds),
    );

    if (response.statusCode == 200) {
      return true;
    }

    return false;
  }

  Future<bool> addUserFavorite(
      String userId, int companyId, String token) async {
    final response = await http.post('$url/users/$userId/favorites',
        headers: {
          "Content-Type": "application/json",
          HttpHeaders.authorizationHeader: "bearer $token"
        },
        body: json.encode(companyId));

    if (response.statusCode == 200) {
      return true;
    }

    return false;
  }

  Future<List<Company>> getUserFavorites(String userId, String token) async {
    final response = await http.get('$url/users/$userId/favorites',
        headers: {HttpHeaders.authorizationHeader: "bearer $token"});

    if (response.statusCode == 200) {
      List<dynamic> list = json.decode(response.body);
      return list.map((model) => Company.fromJson(model)).toList();
    }

    return [];
  }

  Future<User> getUser(String userId, String token) async {
    final response = await http.get('$url/users/$userId',
        headers: {HttpHeaders.authorizationHeader: "bearer $token"});

    if (response.statusCode == 200) {
      dynamic user = json.decode(response.body);
      return User.fromJson(user);
    }

    return null;
  }

  Future<List<Appoint>> getAppointments(String userId, String token) async {
    final response = await http.get('$url/users/$userId/appointments',
        headers: {HttpHeaders.authorizationHeader: "bearer $token"});

    if (response.statusCode == 200) {
      List<dynamic> list = json.decode(response.body);
      return list.map((model) => Appoint.fromJson(model)).toList();
    }

    return [];
  }
}
