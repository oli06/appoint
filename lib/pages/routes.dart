import 'package:appoint/home.dart';
import 'package:appoint/pages/appointment_details.dart';
import 'package:appoint/pages/login.dart';
import 'package:appoint/pages/signup.dart';

final routes = {
  '/signup': (context) => SignUp(),
  '/app': (context) => HomePage(),
  '/': (context) => Login(),
  //'/company': (context) => CompanyPage(),
  AppointmentDetails.routeName: (context) => AppointmentDetails(),
};
