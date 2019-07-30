import 'package:appoint/models/user.dart';
import 'package:location/location.dart';

class AuthenticateAction {}

class UpdateLoginProcessIsActiveAction {
  final bool loginProcessIsActive;

  UpdateLoginProcessIsActiveAction(this.loginProcessIsActive);
}

class UserLoginAction {
  final String username;
  final String password;

  UserLoginAction(this.username, this.password);
}

class LoadedUserConfigurationAction {
  final String token;
  final User user;

  LoadedUserConfigurationAction(this.user, this.token);
}

class LoadedUsernameAction {
  final String username;

  LoadedUsernameAction(this.username);
}

class LoadedUserAction {
  final String token;
  final User user;

  LoadedUserAction(this.user, this.token);
}

class VerifyUserAction {
  final String userId;
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

class LoadUserLocationAction {}

class LoadedUserLocationAction {
  final LocationData location;

  LoadedUserLocationAction(this.location);
}

class RemoveFromUserFavoritesAction {
  final List<int> companyIds;
  final String userId;

  RemoveFromUserFavoritesAction(this.companyIds, this.userId);
}

class AddToUserFavoritesAction {
  final int companyId;
  final String userId;

  AddToUserFavoritesAction(this.companyId, this.userId);
}
