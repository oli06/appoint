import 'package:appoint/data/api.dart';
import 'package:appoint/data/api_interface.dart';
import 'package:appoint/data/dummy_api.dart';
import 'package:appoint/data/request_result.dart';
import 'package:appoint/environment/env.dart';
import 'package:appoint/models/appoint.dart';
import 'package:appoint/models/category.dart';
import 'package:appoint/models/company.dart';
import 'package:appoint/models/period.dart';
import 'package:appoint/models/sync.dart';
import 'package:appoint/models/user.dart';
import 'package:appoint/models/useraccount.dart';

class ApiBase extends ApiInterface {
  static final ApiBase _api = ApiBase._internal();

  factory ApiBase() {
    return _api;
  }

  String token;
  int userId;

  final bool _development = config['development'];
  final Api _productionApi =
      new Api(baseUrl: config['baseUrl'], accessPoint: config['accessPoint']);
  final DummyApi _developmentApi = new DummyApi();

  ApiInterface get _publicApi =>
      _development == true ? _developmentApi : _productionApi;

  ApiBase._internal();

  @override
  Future<bool> addUserFavorite(int companyId) {
    return _publicApi.addUserFavorite(companyId);
  }

  @override
  Future<List<Appoint>> getAppointments() {
    return _publicApi.getAppointments();
  }

  @override
  Future<List<Category>> getCategories() {
    return _publicApi.getCategories();
  }

  @override
  Future<List<Company>> getCompanies(String searchTerm) {
    return _publicApi.getCompanies(searchTerm);
  }

  @override
  Future<Period> getNextPeriod(int companyId) {
    return _publicApi.getNextPeriod(companyId);
  }

  @override
  Future<List<Appoint>> getPastAppointments() {
    return _publicApi.getPastAppointments();
  }

  @override
  Future<Map<DateTime, List<Period>>> getPeriods(
      int companyId, DateTime first, DateTime last) {
    return _publicApi.getPeriods(companyId, first, last);
  }

  @override
  Future<RequestResult<Sync>> getSyncFlags() {
    return _publicApi.getSyncFlags();
  }

  @override
  Future<RequestResult<User>> getUser() {
    return _publicApi.getUser();
  }

  @override
  Future<List<Company>> getUserFavorites() {
    return _publicApi.getUserFavorites();
  }

  @override
  Future<RequestResult> login(String username, String password) {
    return _publicApi.login(username, password);
  }

  @override
  Future<bool> postAppointment(Appoint appoint) {
    return _publicApi.postAppointment(appoint);
  }

  @override
  Future<RequestResult<bool>> register(UserAccount user) {
    return _publicApi.register(user);
  }

  @override
  Future<bool> removeUserFavorites(List<int> companyIds) {
    return _publicApi.removeUserFavorites(companyIds);
  }

  @override
  Future<bool> updateAppointment(Appoint appoint) {
    return _publicApi.updateAppointment(appoint);
  }

  @override
  Future<bool> verifyUser(String code) {
    return _publicApi.verifyUser(code);
  }
}
