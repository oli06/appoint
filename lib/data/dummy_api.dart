import 'package:appoint/data/api_interface.dart';
import 'package:appoint/data/request_result.dart';
import 'package:appoint/models/appoint.dart';
import 'package:appoint/models/category.dart';
import 'package:appoint/models/company.dart';
import 'package:appoint/models/period.dart';
import 'package:appoint/models/sync.dart';
import 'package:appoint/models/user.dart';
import 'package:appoint/models/useraccount.dart';
import 'dart:convert';

import 'package:intl/intl.dart';

class DummyApi extends ApiInterface {
  @override
  Future<bool> addUserFavorite(int companyId) {
    // TODO: implement addUserFavorite
    return null;
  }

  @override
  Future<List<Appoint>> getAppointments() {
    List<dynamic> data = dummyData['appointments'];
    return Future.delayed(Duration(milliseconds: 500))
        .then((_) => data.map((a) => Appoint.fromJson(a)).toList());
  }

  @override
  Future<List<Category>> getCategories() {
    List<dynamic> data = dummyData['categories'];
    return Future.delayed(Duration(milliseconds: 500))
        .then((_) => data.map((c) => Category.fromJson(c)).toList());
  }

  @override
  Future<List<Company>> getCompanies(String searchTerm) {
    List<dynamic> data = dummyData['companies'];
    return Future.delayed(Duration(milliseconds: 500))
        .then((_) => data.map((c) => Company.fromJson(c)).toList());
  }

  @override
  Future<Period> getNextPeriod(int companyId) {
    final nextPeriod = Period(
        duration: Duration(minutes: 45),
        start: DateTime.now().add(Duration(days: 1)));
    return Future.delayed(Duration(milliseconds: 200)).then((_) => nextPeriod);
  }

  @override
  Future<List<Appoint>> getPastAppointments() {
    // TODO: implement getPastAppointments
    return null;
  }

  @override
  Future<Map<DateTime, List<Period>>> getPeriods(
      int companyId, DateTime first, DateTime last) {
    List<dynamic> data = dummyData['periods'];
    Map<DateTime, List<Period>> map = {};
    List<Period> result = data.map((p) => Period.fromJson(p)).toList();

    for (int i = 0; i < data.length; i++) {
      final item = result[i];
      DateTime date =
          DateTime(item.start.year, item.start.month, item.start.day);
      if (!map.containsKey(date)) {
        map.putIfAbsent(date, () => [item]);
      } else {
        map[date].add(item);
      }
    }
    return Future.delayed(Duration(milliseconds: 500)).then((_) => map);
  }

  @override
  Future<RequestResult<Sync>> getSyncFlags() {
    // TODO: implement getSyncFlags
    return null;
  }

  @override
  Future<RequestResult<User>> getUser() {
    dynamic dd = dummyData['user'];
    return Future.delayed(Duration(milliseconds: 500))
        .then((_) => RequestResult.success(User.fromJson(dd)));
  }

  @override
  Future<List<Company>> getUserFavorites() {
    // TODO: implement getUserFavorites
    return null;
  }

  @override
  Future<RequestResult> login(String username, String password) {
    return Future.delayed(Duration(milliseconds: 500)).then((_) =>
        RequestResult.success(({'access_token': "123123123", 'userId': "4"})));
  }

  @override
  Future<bool> postAppointment(Appoint appoint) {
    return Future.delayed(Duration(milliseconds: 500)).then((_) => true);
  }

  @override
  Future<RequestResult<bool>> register(UserAccount user) {
    // TODO: implement register
    return null;
  }

  @override
  Future<bool> removeUserFavorites(List<int> companyIds) {
    // TODO: implement removeUserFavorites
    return null;
  }

  @override
  Future<bool> updateAppointment(Appoint appoint) {
    // TODO: implement updateAppointment
    return null;
  }

  @override
  Future<bool> verifyUser(String code) {
    // TODO: implement verifyUser
    return null;
  }
}

Map dummyData = {
  "user": {
    'userId': 4,
    'firstName': 'Maximilian',
    'lastName': 'Mustermann',
    'isVerified': true,
    'email': 'max@mustermail.com'
  },
  "companies": [
    {
      "id": 1,
      "name": "Steuerberater Hubert",
      "address": {
        "street": "Wunderallee",
        "houseNumber": "47c",
        "city": "Berlin",
        "postal": "14444",
      },
      "rating": 4.5,
      "category": 2,
      "isPartner": true,
      "description": "Wir beraten Sie bei Ihrer Steuerhinterziehung",
      "avatar": "",
      "phone": "+49 1234 5798"
    },
    {
      "id": 2,
      "name": "Hans&Maier Beratung",
      "address": {
        "street": "Wunderallee",
        "houseNumber": "47c",
        "city": "Berlin",
        "postal": "14444",
      },
      "rating": 2.2,
      "category": 2,
      "isPartner": true,
      "description": "Wir beraten Sie bei Ihrer Steuerhinterziehung",
      "avatar": "",
      "phone": "+49 1234 8111"
    },
    {
      "id": 3,
      "name": "Zahnarzt Lucke",
      "address": {
        "street": "Wunderallee",
        "houseNumber": "47c",
        "city": "Berlin",
        "postal": "14444",
      },
      "rating": 1.2,
      "category": 1,
      "isPartner": true,
      "description": "Sie brauchen kaputte Zähne? Wir liefern gerne!",
      "avatar": "",
      "phone": "+49 1234 5798"
    },
    {
      "id": 3,
      "name": "Allgemeinarzt Dr. House",
      "address": {
        "street": "Wunderallee",
        "houseNumber": "47c",
        "city": "Berlin",
        "postal": "14444",
      },
      "rating": 5.0,
      "category": 1,
      "isPartner": true,
      "description": "Wir liefern gerne!",
      "avatar": "",
      "phone": "+49 1234 5798"
    },
  ],
  "appointments": [
    {
      "title": "Friseurtermin",
      "company": {
        "id": 3,
        "name": "Allgemeinarzt Dr. House",
        "address": {
          "street": "Wunderallee",
          "houseNumber": "47c",
          "city": "Berlin",
          "postal": "14444",
        },
        "rating": 5.0,
        "category": 1,
        "isPartner": true,
        "description": "Wir liefern gerne!",
        "avatar": "",
        "phone": "+49 1234 5798"
      },
      "period": {
        "duration": 60,
        "start": "20200303T12:30",
      },
      "description":
          "Lang ersehnter Friseurtermin zum Haare waschen und schneiden.",
      "id": 1
    },
    {
      "title": "Steuertermin",
      "company": {
        "id": 1,
        "name": "Steuerberater Hubert",
        "address": {
          "street": "Wunderallee",
          "houseNumber": "47c",
          "city": "Berlin",
          "postal": "14444",
        },
        "rating": 4.5,
        "category": 2,
        "isPartner": true,
        "description": "Wir beraten Sie bei Ihrer Steuerhinterziehung",
        "avatar": "",
        "phone": "+49 1234 5798"
      },
      "period": {
        "duration": 120,
        "start": "20200304T08:40",
      },
      "description": "Termin für die Steuerhinterziehung.",
      "id": 2
    },
  ],
  "periods": [
    {
      "start": "20200214T08:00",
      "duration": 20,
    },
    {
      "start": "20200214T09:00",
      "duration": 60,
    },
    {
      "start": "20200214T12:00",
      "duration": 50,
    },
    {
      "start": "20200214T13:00",
      "duration": 60,
    },
    {
      "start": "20200215T08:00",
      "duration": 60,
    },
    {
      "start": "20200215T09:00",
      "duration": 30,
    },
    {
      "start": "20200215T10:00",
      "duration": 180,
    },
    {
      "start": "20200215T11:00",
      "duration": 60,
    },
  ],
  "categories": [
    {"value": "Arzt", "id": 1},
    {"value": "Steuerberater", "id": 2}
  ]
};
