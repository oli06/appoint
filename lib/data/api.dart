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

String baseUrl = "https://appointservice.azurewebsites.net/";
String accessPoint = "api/";
String url = baseUrl + accessPoint;

class Api {
  String token;
  String userId;

  Api({
    this.token,
    this.userId = "",
  });

  Future<List<Company>> getCompanies(String searchTerm) async {
    String uri = '$url/companies$searchTerm';

    print("getCompanies uri: $uri");
    final response = await http
        .get(uri, headers: {HttpHeaders.authorizationHeader: "bearer $token"});

    if (response.statusCode == 200) {
      List<dynamic> list = json.decode(response.body);
      return list.map((model) => Company.fromJson(model)).toList();
    }

    return [];
  }

  Future<List<Category>> getCategories() async {
    final response = await http.get('$url/categories',
        headers: {HttpHeaders.authorizationHeader: "bearer $token"});

    if (response.statusCode == 200) {
      List<dynamic> list = json.decode(response.body);
      return list.map((c) => Category.fromJson(c)).toList();
    }

    return [];
  }

  Future<bool> postUserVerificationCode(String code) async {
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

  Future<bool> removeUserFavorites(List<int> companyIds) async {
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

  Future<bool> addUserFavorite(int companyId) async {
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

  Future<List<Company>> getUserFavorites() async {
    final response = await http.get('$url/users/$userId/favorites',
        headers: {HttpHeaders.authorizationHeader: "bearer $token"});

    if (response.statusCode == 200) {
      List<dynamic> list = json.decode(response.body);
      return list.map((model) => Company.fromJson(model)).toList();
    }

    return [];
  }

  Future<User> getUser() async {
    final response = await http.get('$url/users/$userId',
        headers: {HttpHeaders.authorizationHeader: "bearer $token"});

    if (response.statusCode == 200) {
      dynamic user = json.decode(response.body);
      return User.fromJson(user);
    }

    return null;
  }

  Future<List<Appoint>> getAppointments(String userId) async {
    final response = await http.get('$url/users/$userId/appointments',
        headers: {HttpHeaders.authorizationHeader: "bearer $token"});

    if (response.statusCode == 200) {
      List<dynamic> list = json.decode(response.body);
      return list.map((model) => Appoint.fromJson(model)).toList();
    }

    return [];
  }

  Future<bool> postAppointment(Appoint appoint) async {
    final body = appoint.toJson();
    final response = await http.post(
      '$url/users/$userId/appointments',
      headers: {HttpHeaders.authorizationHeader: "bearer $token"},
      body: body,
    );

    if (response.statusCode == 200) {
      return true;
    }

    return false;
  }
}
