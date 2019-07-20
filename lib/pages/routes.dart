import 'package:appoint/home.dart';
import 'package:appoint/pages/appointment_details.dart';
import 'package:appoint/pages/company_details.dart';
import 'package:appoint/pages/favorites.dart';
import 'package:appoint/pages/login.dart';
import 'package:appoint/pages/settings.dart';
import 'package:appoint/pages/signup.dart';

final routes = {
  SignUp.routeName: (context) => SignUp(),
  Login.namedRoute: (context) => Login(),
  CompanyDetails.routeName: (context) => CompanyDetails(),
  AppointmentDetails.routeName: (context) => AppointmentDetails(),
  FavoritesPage.routeName: (context) => FavoritesPage(),
  SettingsPage.routeName: (context) => SettingsPage(),
  'app': (context) => HomePage(),

};
