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

class LoadedUserAction {
  final String token;
  final User user;

  LoadedUserAction(this.user, this.token);
}

class UpdateApiPropertiesAction {
  final int userId;
  final String token;

  UpdateApiPropertiesAction(
    this.userId,
    this.token,
  );
}

class VerifyUserAction {
  final String verificationCode;

  VerifyUserAction(this.verificationCode);
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

  RemoveFromUserFavoritesAction(this.companyIds);
}

class AddToUserFavoritesAction {
  final int companyId;

  AddToUserFavoritesAction(this.companyId);
}
