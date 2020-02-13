import 'dart:io';

import 'package:appoint/data/api_interface.dart';
import 'package:appoint/data/request_result.dart';
import 'package:appoint/models/appoint.dart';
import 'package:appoint/models/category.dart';
import 'package:appoint/models/company.dart';
import 'package:appoint/models/dayresponse.dart';
import 'package:appoint/models/period.dart';
import 'package:appoint/models/sync.dart';
import 'package:appoint/models/user.dart';
import 'package:appoint/models/useraccount.dart';
import 'package:appoint/utils/parse.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

class Api extends ApiInterface {
  String get url => baseUrl + accessPoint;
  String baseUrl;
  String accessPoint;
  Api({
    @required this.baseUrl,
    @required this.accessPoint,
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

  Future<Period> getNextPeriod(int companyId) async {
    final response = await http.get(
      "$url/companies/$companyId/periods?start=${Parse.dateRequestFormat.format(DateTime.now())}&count=1",
      headers: {HttpHeaders.authorizationHeader: "bearer $token"},
    );

    if (response.statusCode == 200) {
      final List<dynamic> dyn = json.decode(response.body);

      final dayObj = DayResponse.fromJson(dyn[0]);
      return dayObj.periods[0];
    }

    return null;
  }

  Future<RequestResult<bool>> register(UserAccount user) async {
    final jsonString = user.toJson();
    final response = await http.post('$url/users/register', body: jsonString);

    if (response.statusCode == 200) {}

    return RequestResult.failed(
      AppointWebserviceError.fromJson(json.decode(response.body)),
      response.statusCode,
    );
  }

  Future<RequestResult<dynamic>> login(String username, String password) async {
    print("login request $username, pw: $password");
    final body = {
      "grant_type": "password",
      "username": username,
      "password": password
    };

    final response = await http.post('${baseUrl}token', body: body);

    if (response.statusCode == 200) {
      return RequestResult.success(json.decode(response.body));
    }

    return RequestResult.failed(
      AppointWebserviceError.fromJson(json.decode(response.body)),
      response.statusCode,
    );
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

  Future<RequestResult<Sync>> getSyncFlags() async {
    final response = await http.get('$url/users/$userId/sync',
        headers: {HttpHeaders.authorizationHeader: "bearer $token"});

    if (response.statusCode == 200) {
      dynamic sync = json.decode(response.body);
      return RequestResult.success(Sync.fromJson(sync));
    }

    return RequestResult.failed(
      AppointWebserviceError.fromJson(json.decode(response.body)),
      response.statusCode,
    );
  }

  Future<RequestResult<User>> getUser() async {
    final response = await http.get('$url/users/$userId',
        headers: {HttpHeaders.authorizationHeader: "bearer $token"});

    if (response.statusCode == 200) {
      dynamic user = json.decode(response.body);
      return RequestResult.success(User.fromJson(user));
    }

    return RequestResult.failed(
        AppointWebserviceError.fromJson(json.decode(response.body)),
        response.statusCode);
  }

  Future<List<Appoint>> getAppointments() async {
    final response = await http.get('$url/users/$userId/appointments',
        headers: {HttpHeaders.authorizationHeader: "bearer $token"});

    if (response.statusCode == 200) {
      List<dynamic> list = json.decode(response.body);
      return list.map((model) => Appoint.fromJson(model)).toList();
    }

    return [];
  }

  Future<List<Appoint>> getPastAppointments() async {
    final response = await http.get(
        '$url/users/$userId/appointments?before=${Parse.dateRequestFormat.format(DateTime.now())}',
        headers: {HttpHeaders.authorizationHeader: "bearer $token"});

    if (response.statusCode == 200) {
      List<dynamic> list = json.decode(response.body);
      return list.map((model) => Appoint.fromJson(model)).toList();
    }

    return [];
  }

  Future<bool> postAppointment(Appoint appoint) async {
    final body = appoint.toJson();
    final encoded = json.encode(body);
    final response = await http.post(
      '$url/users/$userId/appointments',
      headers: {
        HttpHeaders.authorizationHeader: "bearer $token",
        HttpHeaders.contentTypeHeader: "application/json"
      },
      body: encoded,
    );

    if (response.statusCode == 200) {
      return true;
    }

    return false;
  }

  Future<bool> updateAppointment(Appoint appoint) async {
    final body = appoint.toJson();
    final encoded = json.encode(body);
    final response = await http.put(
      '$url/users/$userId/appointments',
      headers: {
        HttpHeaders.authorizationHeader: "bearer $token",
        HttpHeaders.contentTypeHeader: "application/json"
      },
      body: encoded,
    );

    if (response.statusCode == 200) {
      return true;
    }

    return false;
  }

  @override
  Future<bool> verifyUser(String code) {
    // TODO: implement verifyUser
    return null;
  }
}
