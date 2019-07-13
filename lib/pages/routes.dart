import 'package:appoint/home.dart';
import 'package:appoint/pages/appointment_details.dart';
import 'package:appoint/pages/companies.dart';
import 'package:appoint/pages/company_details.dart';
import 'package:appoint/pages/login.dart';
import 'package:appoint/pages/signup.dart';

final routes = {
  '/signup': (context) => SignUp(),
  '/app': (context) => HomePage(),
  '/': (context) => Login(),
  CompanyDetails.routeName: (context) => CompanyDetails(),
  AppointmentDetails.routeName: (context) => AppointmentDetails(),
};
