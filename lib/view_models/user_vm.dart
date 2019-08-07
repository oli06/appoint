import 'package:appoint/models/user.dart';
import 'package:location/location.dart';

class UserViewModel {
  final User user;
  final bool isLoading;
  final bool loginProcessIsActive;
  final String token;
  final LocationData currentLocation;

  const UserViewModel({
    this.user,
    this.isLoading,
    this.token,
    this.currentLocation,
    this.loginProcessIsActive,
  });

  @override
  int get hashCode =>
      user.hashCode ^
      isLoading.hashCode ^
      loginProcessIsActive.hashCode ^
      token.hashCode ^
      currentLocation.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserViewModel &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          user == other.user &&
          token == other.token &&
          currentLocation == other.currentLocation &&
          loginProcessIsActive == other.loginProcessIsActive;
}
