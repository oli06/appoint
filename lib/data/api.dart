import 'dart:io';

import 'package:appoint/models/appoint.dart';
import 'package:appoint/models/category.dart';
import 'package:appoint/models/company.dart';
import 'package:appoint/models/period.dart';
import 'package:appoint/models/user.dart';
import 'package:appoint/models/useraccount.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

// String url = 'https://ca6b821c.ngrok.io';
String baseUrl = "https://appointservice.azurewebsites.net/";
String accessPoint = "api/";
String url = baseUrl + accessPoint;
//String url = 'http://localhost:8000';

class Api {
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

  Future<List<Period>> getPeriodsForMonth(int companyId) async {
    final response = await http.get("$url/companies/$companyId/periods");

    if (response.statusCode == 200) {
      List<dynamic> list = json.decode(response.body);
      return list.map((entry) => Period.fromJson(entry)).toList();
    }

    return [];
  }

  Future<List<Period>> getPeriods(int companyId) async {
    Future<Socket> future = Socket.connect('localhost', 5252);
    future.then((client) {
      print('connected to server!');
      client.handleError((data) {
        print(data);
      });
      client.listen((data) {
        print(new String.fromCharCodes(data));
        return data;
      }, onDone: () {
        print("Done");
      }, onError: (error, stackTrace) {
        print(error);
        print(stackTrace.toString());
      });

      client.writeln('getPeriods');
    });
    //print('Hello world: ${dart_test.calculate()}!');
    return null;
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
    final jsonString = json.encode(body);
    List<int> bodyBytes = utf8.encode(jsonString);
    final url = baseUrl + "token";
    final response = await http.post(url, body: body);

    return response;
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
