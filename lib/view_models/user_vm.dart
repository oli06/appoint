import 'package:appoint/models/user.dart';
import 'package:location/location.dart';

class UserViewModel {
  final User user;
  final bool isLoading;

  final LocationData currentLocation;

  const UserViewModel({this.user, this.isLoading, this.currentLocation});
}