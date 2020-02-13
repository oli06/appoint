import 'package:appoint/data/request_result.dart';
import 'package:appoint/models/appoint.dart';
import 'package:appoint/models/category.dart';
import 'package:appoint/models/company.dart';
import 'package:appoint/models/period.dart';
import 'package:appoint/models/sync.dart';
import 'package:appoint/models/user.dart';
import 'package:appoint/models/useraccount.dart';

abstract class ApiInterface {
  String token;
  int userId;
  
  Future<List<Company>> getCompanies(String searchTerm);
  Future<List<Category>> getCategories();
  Future<bool> verifyUser(String code);
  Future<Map<DateTime, List<Period>>> getPeriods(int companyId, DateTime first, DateTime last);
  Future<Period> getNextPeriod(int companyId);
  Future<RequestResult<bool>> register(UserAccount user);
  Future<RequestResult<dynamic>> login(String username, String password);
  Future<bool> removeUserFavorites(List<int> companyIds);
  Future<bool> addUserFavorite(int companyId);
  Future<List<Company>> getUserFavorites();
  Future<RequestResult<Sync>> getSyncFlags();
  Future<RequestResult<User>> getUser();
  Future<List<Appoint>> getAppointments();
  Future<List<Appoint>> getPastAppointments();
  Future<bool> postAppointment(Appoint appoint);
  Future<bool> updateAppointment(Appoint appoint);
}