import 'package:appoint/home.dart';
import 'package:appoint/pages/appointment_details.dart';
import 'package:appoint/pages/category_select.dart';
import 'package:appoint/pages/chat.dart';
import 'package:appoint/pages/company_details.dart';
import 'package:appoint/pages/favorites.dart';
import 'package:appoint/pages/login.dart';
import 'package:appoint/pages/notifications.dart';
import 'package:appoint/pages/settings.dart';
import 'package:appoint/pages/signup.dart';
import 'package:appoint/pages/signup_success.dart';

final routes = {
  SignUp.routeName: (context) => SignUp(),
  SignupSuccess.namedRoute: (context) => SignupSuccess(),
  Login.namedRoute: (context) => Login(),
  CompanyDetails.routeName: (context) => CompanyDetails(),
  AppointmentDetails.routeName: (context) => AppointmentDetails(),
  FavoritesPage.routeName: (context) => FavoritesPage(),
  SettingsPage.routeName: (context) => SettingsPage(),
  CategorySelectPage.routeNamed: (context) => CategorySelectPage(),
  //NotificationsPage.routeNamed: (context) => NotificationsPage(),
  ChatPage.namedRoute: (context) => ChatPage(),
  'app': (context) => HomePage(),
};
