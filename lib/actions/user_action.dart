import 'package:appoint/models/user.dart';
import 'package:location/location.dart';

class LoadUserAction {}

class LoadedUserAction {
  final User user;

  LoadedUserAction(this.user);
}

class VerifyUserAction {
  final int userId;
  final String verificationCode;

  VerifyUserAction(this.userId, this.verificationCode);
}

class VerifyUserResultAction {
  final bool success;

  VerifyUserResultAction(this.success);
}

class UpdateUserLoadingAction {
  final bool isLoading;

  UpdateUserLoadingAction(this.isLoading);
}

class LoadUserLocationAction { }

class LoadedUserLocationAction {
  final LocationData location;

  LoadedUserLocationAction(this.location);
}