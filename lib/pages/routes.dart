import 'package:appoint/home.dart';
import 'package:appoint/pages/appointment_details.dart';
import 'package:appoint/pages/login.dart';

final routes = {
  '/': (context) => Login(),
  //'/signup': (context) => SignUp(),
  '/app': (context) => HomePage(),
  //'/company': (context) => CompanyPage(),
  AppointmentDetails.routeName: (context) => AppointmentDetails(),
};
